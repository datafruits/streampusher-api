import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('playlist-tracks-list', 'Integration | Component | playlist tracks list', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{playlist-tracks-list}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#playlist-tracks-list}}
      template block text
    {{/playlist-tracks-list}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
