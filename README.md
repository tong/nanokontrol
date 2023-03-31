# Nanokontrol

Wrapper to access a korg nanokontrol device using webmidi.


### Usage

```hx
NanoKontrol.requestDevice().then(nk -> {
    nk.onInput = (channel,value,timestamp) -> {
        switch channel {
        case F3: // Fader3
            // ...
        case _:
        }
    }
}).catchError(e -> {
    console.warn('Failed to access nanokontrol device');
});
```
