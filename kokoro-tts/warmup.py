from kokoro import KPipeline
from IPython.display import display, Audio
import soundfile as sf
import sys
import subprocess
import os

def check_espeak_installation():
    """Check if espeak-ng is installed and configured properly"""
    try:
        # Try to import espeak-ng
        import espeakng
        return True
    except ImportError:
        print("espeak-ng not found. Installing required packages...")
        try:
            # Install espeak-ng using pip
            subprocess.check_call([sys.executable, "-m", "pip", "install", "espeak-ng"])
            return True
        except subprocess.CalledProcessError:
            print("Error: Failed to install espeak-ng. Please install it manually.")
            return False

# Check espeak-ng installation before proceeding
if not check_espeak_installation():
    sys.exit(1)

# 🇺🇸 'a' => American English, 🇬🇧 'b' => British English
# 🇯🇵 'j' => Japanese: pip install misaki[ja]
# 🇨🇳 'z' => Mandarin Chinese: pip install misaki[zh]
# 🇪🇸 'e' => Spanish, 🇫🇷 'f' => French
# 🇮🇳 'h' => Hindi, 🇮🇹 'i' => Italian
# 🇧🇷 'p' => Brazilian Portuguese
#lang_codes = ['z', 'j', 'a', 'b', 'h', 'i', 'p', 'f', 'e']  # Array of language codes
lang_codes = ['f', 'e', 'h', 'i', 'p', 'z', 'j', 'a', 'b']  # Array of language codes
voices = {
    'z': ['zf_xiaobei', 'zf_xiaoni', 'zf_xiaoxiao', 'zf_xiaoyi', 'zm_yunjian', 'zm_yunxi', 'zm_yunxia', 'zm_yunyang'],
    'j': ['jf_alpha', 'jf_gongitsune', 'jf_nezumi', 'jf_tebukuro', 'jm_kumo'],
    'a': ['af_heart', 'af_alloy', 'af_aoede', 'af_bella', 'af_jessica', 'af_kore', 'af_nicole', 'af_nova', 'af_river', 'af_sarah', 'af_sky', 'am_adam', 'am_echo', 'am_eric', 'am_fenrir', 'am_liam', 'am_michael', 'am_onyx', 'am_puck', 'am_santa'],
    'b': ['bf_alice', 'bf_emma', 'bf_isabella', 'bf_lily', 'bm_daniel', 'bm_fable', 'bm_george', 'bm_lewis'],
    'e': ['ef_dora', 'em_alex', 'em_santa'],
    'f': ['ff_siwis'],
    'h': ['hf_alpha', 'hf_beta', 'hm_omega', 'hm_psi'],
    'i': ['if_sara', 'im_nicola'],
    'p': ['pf_dora', 'pm_alex', 'pm_santa']
}
speed = 1
texts = {
    'z': '普通话中文',
    'j': 'こんにちは',
    'a': 'Hello in American English',
    'b': 'Hello in British English',
    'e': 'Hola, buenos días',
    'f': 'Bonjour tout le monde',
    'h': 'नमस्ते, कैसे हैं आप',
    'i': 'Ciao, buongiorno',
    'p': 'Olá, bom dia'
}

for lang_code in lang_codes:
    print(f"\nProcessing language: {lang_code}")
    try:
        pipeline = KPipeline(lang_code)
        for voice in voices[lang_code]:
            print(f"\nGenerating audio for voice: {voice}")
            try:
                generator = pipeline(
                    texts[lang_code], voice,
                    speed, split_pattern=r'\n+'
                )
                for i, (gs, ps, audio) in enumerate(generator):
                    print(i)  # i => index
                    print(gs)  # gs => graphemes/text
                    print(ps)  # ps => phonemes
                    display(Audio(data=audio, rate=24000, autoplay=i==0))
                    sf.write(f'{voice}_{i}.wav', audio, 24000)  # save each audio file with voice prefix
            except Exception as e:
                print(f"Error processing voice {voice}: {str(e)}")
                continue
    except Exception as e:
        print(f"Error processing language {lang_code}: {str(e)}")
        continue
