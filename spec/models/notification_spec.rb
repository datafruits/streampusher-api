require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:experience_point_award) do
    # Mock object that responds to the methods used in notifications
    double('ExperiencePointAward', amount: 100, award_type: 'beany')
  end

  describe '#set_message' do
    context 'badge award notifications' do
      it 'sets translation key and params for strawberry badge award' do
        notification = Notification.new(
          user: user,
          notification_type: 'strawberry_badge_award',
          source: user,
          send_to_chat: false
        )
        
        notification.save!
        
        expect(notification.message_key).to eq('notifications.badge_award.strawberry')
        expect(notification.message_params).to eq({ 'username' => user.username })
        expect(notification.message).to eq('')
      end

      it 'sets translation key and params for dj badge award' do
        notification = Notification.new(
          user: user,
          notification_type: 'dj_badge_award',
          source: user,
          send_to_chat: false
        )
        
        notification.save!
        
        expect(notification.message_key).to eq('notifications.badge_award.dj')
        expect(notification.message_params).to eq({ 'username' => user.username })
        expect(notification.message).to eq('')
      end
    end

    context 'level up notification' do
      it 'sets translation key and params for level up' do
        user.level = 5
        notification = Notification.new(
          user: user,
          notification_type: 'level_up',
          source: user,
          send_to_chat: false
        )
        
        notification.save!
        
        expect(notification.message_key).to eq('notifications.level_up')
        expect(notification.message_params).to eq({ 'username' => user.username, 'level' => 5 })
        expect(notification.message).to eq('')
      end
    end

    context 'experience point award notification' do
      it 'sets translation key and params for experience point award' do
        notification = Notification.new(
          user: user,
          notification_type: 'experience_point_award',
          source: experience_point_award,
          send_to_chat: false
        )
        
        notification.save!
        
        expect(notification.message_key).to eq('notifications.experience_point_award')
        expect(notification.message_params).to eq({ 'amount' => 100, 'award_type' => 'beany' })
        expect(notification.message).to eq('')
      end
    end
  end
end