import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('playlist-track-li', 'Integration | Component | playlist track li', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{playlist-track-li}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#playlist-track-li}}
      template block text
    {{/playlist-track-li}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
