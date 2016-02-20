import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('streampusher-tracks', 'Integration | Component | streampusher tracks', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{streampusher-tracks}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#streampusher-tracks}}
      template block text
    {{/streampusher-tracks}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
