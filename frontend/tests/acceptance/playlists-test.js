import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | playlists');

test('visiting /playlists', function(assert) {
  visit('/playlists');

  andThen(function() {
    assert.equal(currentURL(), '/playlists');
  });
});
