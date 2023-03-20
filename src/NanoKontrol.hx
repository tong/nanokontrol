
import js.lib.Promise;
import js.html.midi.MIDIInput;
import js.html.midi.MIDIInputMap;
import js.html.midi.MIDIMessageEvent;

enum abstract Channel(Int) from Int to Int {

    // Faders
	var F1 = 2;
	var F2 = 3;
	var F3 = 4;
	var F4 = 5;
	var F5 = 6;
	var F6 = 8;
	var F7 = 9;
	var F8 = 12;
	var F9 = 13;

    // Knobs
	var K1 = 14;
	var K2 = 15;
	var K3 = 16;
	var K4 = 17;
	var K5 = 18;
	var K6 = 19;
	var K7 = 20;
	var K8 = 21;
	var K9 = 22;

    // Channel button 1
	var B1_1 = 23;
	var B2_1 = 24;
	var B3_1 = 25;
    var B4_1 = 26;
    var B5_1 = 27;
    var B6_1 = 28;
    var B7_1 = 29;
    var B8_1 = 30;
    var B9_1 = 31;

    // Channel button 2
	var B1_2 = 33;
	var B2_2 = 34;
	var B3_2 = 35;
    var B4_2 = 36;
    var B5_2 = 37;
    var B6_2 = 38;
    var B7_2 = 39;
    var B8_2 = 40;
    var B9_2 = 41;

    //
	var B_REC = 44;
	var B_PLAY = 45;
	var B_STOP = 46;
	var B_PREV = 47;
	var B_NEXT = 48;
	var B_LOOP = 49;
}

/**
    Korg NanoKrontrol midi device.
**/
class NanoKontrol {

	public static var MANUFACTURER = 'KORG INC.';
	public static var NAME = 'nanoKONTROL nanoKONTROL _ CTRL';

	public dynamic function onInput(channel: Channel, value: Int, timestamp: Float) {}

	public var input : MIDIInput;

	public function new( input : MIDIInput ) {
		this.input = input;
		input.onmidimessage = handleMessage;
	}

	public function handleMessage(e : MIDIMessageEvent) {
		final a = e.data;
		onInput(a[1], a[2], e.timeStamp);
	}

	public static function getDevice(midiInput : MIDIInputMap, ?deviceManufacturer: String, ?deviceName: String) : NanoKontrol {
        if(deviceManufacturer == null) deviceManufacturer = MANUFACTURER;
        if(deviceName == null) deviceName = NAME;
		final inputs = midiInput.values();
		while(true) {
			final input = inputs.next();
			if(input.value == null && input.done) {
				break;
			} else if(input.value.name == deviceName) {
				return new NanoKontrol(input.value);
			}
		}
		return null;
	}

	public static inline function requestDevice() : Promise<NanoKontrol> {
        if(js.Browser.navigator.requestMIDIAccess == null)
            return Promise.reject('cannot access midi devices');
		return js.Browser.navigator.requestMIDIAccess().then(midi -> {
			return NanoKontrol.getDevice(midi.inputs);
		});
	}

}
