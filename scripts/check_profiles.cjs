const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const events = {};
const summary = { focus() { document.activeElement = summary; } };
const link = {};
const profile = {
  open: true, dataset: {},
  addEventListener(type, fn) { events[type] = fn; },
  contains(element) { return element === summary || element === link; },
  querySelector() { return summary; }
};
const document = { activeElement: link, querySelectorAll: () => [profile], addEventListener(type, fn) { events[type] = fn; } };
const script = fs.readFileSync('_includes/author-profile-script.html', 'utf8').replace(/<\/?script>/g, '');
vm.runInNewContext(script, { document });
events.pointerleave?.({ pointerType: 'mouse' });
assert.equal(profile.open, false, 'Mouse departure must close a clicked profile');
assert.equal(document.activeElement, summary, 'Return focus from hidden popup to its summary');
events.toggle();
events.pointerenter({ pointerType: 'mouse' });
assert.equal(profile.dataset.dismissed, undefined, 'Re-entry must allow hover again');
profile.open = true;
events.pointerleave({ pointerType: 'touch' });
assert.equal(profile.open, true, 'Touch release must not close the profile');
events.keydown({ key: 'Escape' });
assert.equal(profile.open, false, 'Escape must still dismiss profiles');
console.log('Profile checks passed: pointer dismissal, focus, re-entry, touch, and Escape.');
