(->
  window.audioMixer = {}
  soundAnalyser = []

  gradient = ["000000","000005","00000A","00010F","000114","000119","00021E","000223","000228","00032D","000332","000337","00043C","000441","000446","00054B","000550","000555","00065A","00065F","000664","000769","00076E","000773","000878","00087D","000882","000987","00098C","000991","000A96","000A9B","000AA0","000BA5","000BAA","000BAF","000CB4","000CB9","000CBE","000DC3","000DC8","000DCD","000ED2","000ED7","000EDC","000FE1","000FE6","000FEB","0010F0","0010F5","0010FA","0011FF","0014FF","0018FF","001BFF","001FFF","0022FF","0026FF","002AFF","002DFF","0031FF","0034FF","0038FF","003CFF","003FFF","0043FF","0046FF","004AFF","004EFF","0051FF","0055FF","0058FF","005CFF","005FFF","0063FF","0067FF","006AFF","006EFF","0071FF","0075FF","0079FF","007CFF","0080FF","0083FF","0087FF","008BFF","008EFF","0092FF","0095FF","0099FF","009CFF","00A0FF","00A4FF","00A7FF","00ABFF","00AEFF","00B2FF","00B6FF","00B9FF","00BDFF","00C0FF","00C4FF","00C8FF","00C9FC","00CAF9","00CBF6","00CCF3","00CDF0","00CEED","00CFEA","00D0E7","00D1E4","00D2E1","00D3DE","00D4DB","00D6D9","00D7D6","00D8D3","00D9D0","00DACD","00DBCA","00DCC7","00DDC4","00DEC1","00DFBE","00E0BB","00E1B8","00E2B5","00E4B3","00E5B0","00E6AD","00E7AA","00E8A7","00E9A4","00EAA1","00EB9E","00EC9B","00ED98","00EE95","00EF92","00F08F","00F28D","00F38A","00F487","00F584","00F681","00F77E","00F87B","00F978","00FA75","00FB72","00FC6F","00FD6C","00FF6A","04FF67","09FF65","0DFF63","12FF61","16FF5F","1BFF5D","20FF5B","24FF59","29FF57","2DFF55","32FF53","37FF51","3BFF4E","40FF4C","44FF4A","49FF48","4EFF46","52FF44","57FF42","5BFF40","60FF3E","64FF3C","69FF3A","6EFF38","72FF36","77FF33","7BFF31","80FF2F","85FF2D","89FF2B","8EFF29","92FF27","97FF25","9CFF23","A0FF21","A5FF1F","A9FF1D","AEFF1B","B2FF18","B7FF16","BCFF14","C0FF12","C5FF10","C9FF0E","CEFF0C","D3FF0A","D7FF08","DCFF06","E0FF04","E5FF02","EAFF00","EAF900","EAF400","EBEF00","EBEA00","ECE500","ECE000","ECDB00","EDD600","EDD100","EECC00","EEC600","EFC100","EFBC00","EFB700","F0B200","F0AD00","F1A800","F1A300","F19E00","F29900","F29300","F38E00","F38900","F48400","F47F00","F47A00","F57500","F57000","F66B00","F66600","F76000","F75B00","F75600","F85100","F84C00","F94700","F94200","F93D00","FA3800","FA3200","FB2D00","FB2800","FC2300","FC1E00","FC1900","FD1400","FD0F00","FE0A00","FE0500","FF0000"]

  # Load file from input locally into a buffer
  # https://github.com/cwilso/PitchDetect/blob/master/js/pitchdetect.js#L40
  #
  # file = document.getElementById('audio-file')
  # audioCtx = new AudioContext()
  # audioBufferNode = audioCtx.createBufferSource()
  # 
  localFileLoad = (file, audioCtx, audioBufferNode) ->
    
    audioFileReader = new FileReader()

    audioFileReader.onload = (event) ->
      audioCtx.decodeAudioData(event.target.result, (buffer) ->
        audioBufferNode.buffer = buffer
      )
    
    audioFileReader.readAsArrayBuffer(file.files[0])

  # Load file into audio tag
  # when audio src is changed needs to be removed with URL.revokeObjectURL()
  # http://lostechies.com/derickbailey/2013/09/23/getting-audio-file-information-with-htmls-file-api-and-audio-element/
  loadFileIntoAudio = (file, audioEl) ->
    audioEl.src = URL.createObjectURL(file.files[0])
    
  # load in a audio alement and route it through the graph
  #

  # source = context.createMediaElementSource(audioElement)
  # source.connect(context.destination)

#     fileInput.addEventListener("change", function() {
# 	var reader = new FileReader();
# 	reader.onload = function(ev) {
# 		context.decodeAudioData(ev.target.result, function(buffer) {
# 			bufferSource.buffer = buffer;
# 			bufferSource.noteOn(0);
# 		});
# 	};
# 	reader.readAsArrayBuffer(this.files[0]);
# }, false);
    
  updateGraph = ->
    requestAnimationFrame(updateGraph)
    

    audioMixer.canvasContext.clearRect(0,0,800,600)
    audioMixer.canvasContext.fillStyle = 'black'
    audioMixer.canvasContext.fillRect(0,0,800,600)
    audioMixer.canvasContext.fillStyle = 'blue'

    audioMixer.analyser.getByteFrequencyData(frequencyData)

    imageData = audioMixer.spectrum.getImageData(1, 0, audioMixer.spectrum.canvas.width-1, audioMixer.spectrum.canvas.height)
    audioMixer.spectrum.putImageData(imageData, 0, 0)

    audioMixer.spectrum.clearRect(audioMixer.spectrum.canvas.width-1, 0, 1, audioMixer.spectrum.canvas.height)
    
    for point, i in frequencyData
      audioMixer.spectrum.fillStyle = "##{gradient[point]}"
      audioMixer.spectrum.fillRect(audioMixer.spectrum.canvas.width - 1, frequencyData.length - 1 - i, 1, 1 )
      audioMixer.canvasContext.fillRect(i*4, 256 - frequencyData[i], 3, 256)

    # draw the wave form
    audioMixer.analyser.getByteTimeDomainData(timeData)
    audioMixer.canvasContext.beginPath()
    audioMixer.canvasContext.moveTo(0,128)

    for data, i in timeData
      audioMixer.canvasContext.lineTo(i*3,data)
    
    audioMixer.canvasContext.strokeStyle="green"
    audioMixer.canvasContext.stroke()

  loadCanvas = ->
    canvas  = document.getElementById("2d-vis")
    spectrum = document.getElementById("spectrum")

    if canvas.getContext
      audioMixer.canvasContext = canvas.getContext('2d')
      audioMixer.spectrum = spectrum.getContext('2d')
    else
      alert('canvas not supported')


  processStream = (stream) ->
    console.log(stream)
    audioMixer.mic = audioMixer.audioContext.createMediaStreamSource(stream)
    
    audioMixer.mic.connect(audioMixer.analyser)
    

    # // Connect it to the destination.

  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia ||navigator.mozGetUserMedia || navigator.msGetUserMedia
  
  window.AudioContext = window.AudioContext || window.webkitAudioContext || window.mozAudioContext

  loadCanvas()
  
  audioMixer.spectrum.clearRect(0,0,800,600)
  audioMixer.spectrum.fillStyle = 'black'
  audioMixer.spectrum.fillRect(0,0,800,600)

  audioMixer.audioContext = new AudioContext()

  audioMixer.analyser = audioMixer.audioContext.createAnalyser()
  audioMixer.analyser.fftSize = 512
    
  frequencyData = new Uint8Array(audioMixer.analyser.frequencyBinCount)
  timeData = new Uint8Array(audioMixer.analyser.frequencyBinCount)

  navigator.getUserMedia( {audio:true}, processStream, -> console.log('no media') )
  updateGraph()
  
)()
