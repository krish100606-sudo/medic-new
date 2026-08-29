/**
 * MediKiosk Voice Recognition Module
 * Uses Web Speech API with support for English and Hindi voice input.
 * Allows instant live transcription into editable inputs.
 */

class MediKioskVoice {
  constructor(options = {}) {
    this.targetInputId = options.targetInputId || 'answerInput';
    this.micButtonId = options.micButtonId || 'micBtn';
    this.statusElementId = options.statusElementId || 'voiceStatus';
    this.lang = options.lang || 'en-IN'; // 'en-IN' or 'hi-IN'
    this.recognition = null;
    this.isRecording = false;

    this.init();
  }

  init() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) {
      this.updateStatus('Voice recognition is not supported in this browser. Please type your answer.', 'text-muted');
      const micBtn = document.getElementById(this.micButtonId);
      if (micBtn) micBtn.disabled = true;
      return;
    }

    this.recognition = new SpeechRecognition();
    this.recognition.continuous = false;
    this.recognition.interimResults = true;
    this.recognition.lang = this.lang;

    this.recognition.onstart = () => {
      this.isRecording = true;
      this.updateStatus('Listening... Speak clearly into your microphone.', 'text-primary');
      const micBtn = document.getElementById(this.micButtonId);
      if (micBtn) micBtn.classList.add('recording');
    };

    this.recognition.onresult = (event) => {
      let transcript = '';
      for (let i = event.resultIndex; i < event.results.length; ++i) {
        transcript += event.results[i][0].transcript;
      }
      const targetInput = document.getElementById(this.targetInputId);
      if (targetInput) {
        targetInput.value = transcript;
        // Trigger change event
        targetInput.dispatchEvent(new Event('input', { bubbles: true }));
      }
    };

    this.recognition.onerror = (event) => {
      this.isRecording = false;
      this.updateStatus('Speech recognition error: ' + event.error + '. You can edit or type manually.', 'text-danger');
      const micBtn = document.getElementById(this.micButtonId);
      if (micBtn) micBtn.classList.remove('recording');
    };

    this.recognition.onend = () => {
      this.isRecording = false;
      this.updateStatus('Voice input captured. You can edit the text if needed.', 'text-success');
      const micBtn = document.getElementById(this.micButtonId);
      if (micBtn) micBtn.classList.remove('recording');
    };

    const micBtn = document.getElementById(this.micButtonId);
    if (micBtn) {
      micBtn.addEventListener('click', () => {
        this.toggle();
      });
    }
  }

  toggle() {
    if (!this.recognition) return;
    if (this.isRecording) {
      this.recognition.stop();
    } else {
      try {
        this.recognition.start();
      } catch (err) {
        this.recognition.stop();
      }
    }
  }

  updateStatus(message, className) {
    const el = document.getElementById(this.statusElementId);
    if (el) {
      el.className = 'small mt-2 ' + className;
      el.textContent = message;
    }
  }
}

window.MediKioskVoice = MediKioskVoice;
