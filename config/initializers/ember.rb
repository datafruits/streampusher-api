# config/intializers/ember.rb
EmberCli.instance_variable_set(:@root, Rails.root.join("public/assets/ember-cli").tap(&:mkpath))
EmberCli.configure do |c|
   c.app :frontend, exclude_ember_deps: "jquery", yarn: true
end
