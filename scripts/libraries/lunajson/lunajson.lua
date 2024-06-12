local newdecoder = require 'scripts.libraries.lunajson.decoder'
local newencoder = require 'scripts.libraries.lunajson.encoder'
local sax = require 'scripts.libraries.lunajson.sax'
-- If you need multiple contexts of decoder and/or encoder,
-- you can require lunajson.decoder and/or lunajson.encoder directly.
return {
	decode = newdecoder(),
	encode = newencoder(),
	newparser = sax.newparser,
	newfileparser = sax.newfileparser,
}
