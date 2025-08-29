require 'rails_helper'

RSpec.describe 'Label consolidation script', type: :integration do
  let!(:radio) { FactoryBot.create(:radio) }
  
  describe 'consolidate_duplicate_labels.rb' do
    context 'when there are duplicate labels' do
      let!(:track1) { FactoryBot.create(:track, radio: radio) }
      let!(:track2) { FactoryBot.create(:track, radio: radio) }
      let!(:scheduled_show) { FactoryBot.create(:scheduled_show, radio: radio) }
      
      let!(:label1) do
        # Create the first label normally
        Label.create!(name: 'test label', radio: radio, created_at: 1.day.ago)
      end
      
      let!(:label2) do
        # Create duplicate by bypassing validation
        label = Label.new(name: 'test label', radio: radio, created_at: Time.current)
        label.save!(validate: false)
        label
      end
      
      before do
        # Create associations for both labels
        TrackLabel.create!(track: track1, label: label1)
        TrackLabel.create!(track: track2, label: label2)
        ScheduledShowLabel.create!(scheduled_show: scheduled_show, label: label1)
      end
      
      it 'consolidates duplicate labels and preserves associations' do
        expect(Label.where(name: 'test label', radio: radio).count).to eq(2)
        
        # Capture output to verify script runs
        output = capture_stdout do
          load Rails.root.join('script', 'consolidate_duplicate_labels.rb')
        end
        
        expect(output).to include('Consolidating 2 duplicate labels')
        
        # Should only have one label remaining
        remaining_labels = Label.where(name: 'test label', radio: radio)
        expect(remaining_labels.count).to eq(1)
        
        # The remaining label should be the older one
        remaining_label = remaining_labels.first
        expect(remaining_label.id).to eq(label1.id)
        
        # All track associations should be preserved
        expect(remaining_label.tracks).to include(track1, track2)
        expect(remaining_label.track_labels.count).to eq(2)
        
        # Show associations should be preserved
        expect(remaining_label.scheduled_shows).to include(scheduled_show)
        expect(remaining_label.scheduled_show_labels.count).to eq(1)
      end
      
      it 'supports dry run mode' do
        expect(Label.where(name: 'test label', radio: radio).count).to eq(2)
        
        # Set dry run mode
        ENV['DRY_RUN'] = 'true'
        
        # Capture output to verify script runs in dry run mode
        output = capture_stdout do
          load Rails.root.join('script', 'consolidate_duplicate_labels.rb')
        end
        
        # Reset environment
        ENV.delete('DRY_RUN')
        
        expect(output).to include('DRY RUN MODE')
        expect(output).to include('[DRY RUN] Would consolidate')
        
        # Labels should not be modified in dry run mode
        expect(Label.where(name: 'test label', radio: radio).count).to eq(2)
        expect(Label.find(label1.id)).to be_present
        expect(Label.find(label2.id)).to be_present
      end
    end
    
    context 'when there are no duplicate labels' do
      let!(:label1) { Label.create!(name: 'unique label 1', radio: radio) }
      let!(:label2) { Label.create!(name: 'unique label 2', radio: radio) }
      
      it 'does not modify any labels' do
        expect(Label.count).to eq(2)
        
        # Capture output to verify script runs
        output = capture_stdout do
          load Rails.root.join('script', 'consolidate_duplicate_labels.rb')
        end
        
        expect(output).to include('Starting label consolidation')
        
        # Should still have both labels
        expect(Label.count).to eq(2)
        expect(Label.find(label1.id)).to be_present
        expect(Label.find(label2.id)).to be_present
      end
    end
    
    context 'when labels belong to different radios' do
      let!(:radio2) { FactoryBot.create(:radio) }
      let!(:label1) { Label.create!(name: 'same name', radio: radio) }
      let!(:label2) { Label.create!(name: 'same name', radio: radio2) }
      
      it 'does not consolidate labels from different radios' do
        expect(Label.where(name: 'same name').count).to eq(2)
        
        # Run the consolidation script
        load Rails.root.join('script', 'consolidate_duplicate_labels.rb')
        
        # Should still have both labels since they belong to different radios
        expect(Label.where(name: 'same name').count).to eq(2)
        expect(Label.find(label1.id)).to be_present
        expect(Label.find(label2.id)).to be_present
      end
    end
  end
  
  private
  
  def capture_stdout
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end
end