from kokoro import KPipeline
from IPython.display import display, Audio
import soundfile as sf
import sys
import argparse
import os

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

# Dictionary for difficult American English words
EN_WORD_MAP = {
    'kokoro': 'ko ko ro',
    'github': 'git hub',
    'javascript': 'java script',
    'kubernetes': 'koo ber net ees',
    'nginx': 'en jin ex',
    'ubuntu': 'oo boon too',
    'linux': 'lin nux',
    'azure': 'azh ur',
    'mysql': 'my ess que el',
    'postgresql': 'post gress que el',
    'redis': 're diss',
    'django': 'jan go',
    'numpy': 'num pie',
    'scipy': 'sigh pie',
    'tensorflow': 'ten sor flow',
    'pytorch': 'pie torch',
    'ansible': 'an si bul',
    'maven': 'may ven',
    'alibaba': 'ah li ba ba',
    'qwen': 'quin',
    'doubao': 'dow bao'
}

# Chinese punctuation mapping (with two spaces after)
CN_PUNCT_MAP = {
    '，': ',  ',
    '。': '.  ',
    '！': '!  ',
    '？': '?  ',
    '；': ';  ',
    '：': '  ',
    '“': '  ',
    '”': '  ',
    '‘': "  ",
    '’': "  ",
    '（': '(  ',
    '）': ')  ',
    '【': '[  ',
    '】': ']  ',
    '《': '  ',
    '》': '  ',
    '、': ',  ',
    '～': '~  ',
    '…': '...  '
}

def normalize_english_words(text):
    """Replace difficult English words with syllable-broken versions (case-insensitive)"""
    words = text.split()
    for i, word in enumerate(words):
        # Normalize different types of apostrophes
        word_lower = word.lower().replace("'","'").replace("’","'").replace("`","'")

        # Store any trailing punctuation
        trailing_punctuation = ''
        if word_lower[-1] in ",.!?;:":
            trailing_punctuation = word_lower[-1]
            word_lower = word_lower[:-1]  # Remove the punctuation for normalization

        # Remove possessive forms
        stripped_word = word_lower.rstrip("'s")  # Remove possessive 's
        stripped_word = stripped_word.rstrip("s'")  # Remove plural possessive s'

        # Check if the stripped word is in the mapping
        if stripped_word in EN_WORD_MAP:
            replacement = EN_WORD_MAP[stripped_word]
            # Determine if it was possessive or plural
            if word_lower.endswith("'s"):
                replacement += "'s"
            elif word_lower.endswith("s'"):
                replacement += "s'"

            # Reattach any trailing punctuation
            replacement += trailing_punctuation

            # Match original case
            if word.isupper():
                words[i] = replacement.upper()
            elif word.istitle():
                words[i] = replacement.title()
            else:
                words[i] = replacement
        else:
            # If the word is not in the map, keep it unchanged
            words[i] = word

    return ' '.join(words)

def normalize_chinese_punctuation(text):
    """Replace Chinese punctuation marks with English ones followed by two spaces"""
    for cn_punct, en_punct in CN_PUNCT_MAP.items():
        text = text.replace(cn_punct, en_punct)
    return text

def get_output_dir():
    """Determine the output directory for wav files"""
    if os.path.exists('/out') and os.path.isdir('/out'):
        return '/out'
    return '/tmp'

def check_existing_files(output_dir, text, lang_code, voice, speed):
    """Check if any output files would be overwritten"""
    # Create a generator to simulate the number of segments
    pipeline = KPipeline(lang_code)
    generator = pipeline(text, voice, speed, split_pattern=r'\n+')
    
    # Count segments and check for existing files
    existing_files = []
    segment_count = 0
    for i, _ in enumerate(generator):
        path = os.path.join(output_dir, f'{i}.wav')
        if os.path.exists(path):
            existing_files.append(path)
        segment_count = i + 1
    
    return existing_files, segment_count

def add_padding_spaces(text):
    """Add two spaces before and after the text"""
    return f"  {text}  "

def main():
    parser = argparse.ArgumentParser(description='Text-to-Speech using Kokoro')
    parser.add_argument('lang_code', choices=lang_codes, help=f'Language code ({", ".join(lang_codes)})')
    parser.add_argument('voice_index', type=int, help='Voice index (zero-based)')
    parser.add_argument('text', help='Text to synthesize')
    parser.add_argument('--speed', type=float, default=1.0, help='Speech speed (default: 1.0)')
    args = parser.parse_args()

    print(f"ARG: lang_code: {args.lang_code}")
    print(f"ARG: voice_index: {args.voice_index}")
    print(f"ARG: text: {args.text}")

    # Check if language code has voices
    if args.lang_code not in voices:
        print(f"Error: No voices available for language code '{args.lang_code}'")
        sys.exit(1)

    # Validate voice index
    if args.voice_index < 0 or args.voice_index >= len(voices[args.lang_code]):
        print(f"Error: Voice index must be between 0 and {len(voices[args.lang_code])-1} for language code '{args.lang_code}'")
        print(f"Available voices for {args.lang_code}:")
        for i, voice in enumerate(voices[args.lang_code]):
            print(f"  {i}: {voice}")
        sys.exit(1)

    # Get the selected voice
    voice = voices[args.lang_code][args.voice_index]
    print(f"Selected voice: {voice}")

    # Process text based on language
    text = args.text
    if args.lang_code == 'z':
        text = normalize_chinese_punctuation(text)
        print(f"Normalized text: {text}")
    elif args.lang_code == 'a':
        text = normalize_english_words(text)
        print(f"Normalized text: {text}")

    # Get output directory
    output_dir = get_output_dir()
    print(f"Output directory: {output_dir}")

    # Check for existing files
    existing_files, segment_count = check_existing_files(output_dir, text, args.lang_code, voice, args.speed)
    if existing_files:
        print("Error: The following files already exist:")
        for file in existing_files:
            print(f"  {file}")
        print(f"\nTotal segments to generate: {segment_count}")
        print("Please remove existing files before running again.")
        sys.exit(1)

    # Initialize pipeline and generate audio
    pipeline = KPipeline(args.lang_code)
    generator = pipeline(
        text, voice,
        args.speed, split_pattern=r'\n+'
    )

    for i, (gs, ps, audio) in enumerate(generator):
        print(f"Segment {i}:")
        # Add padding spaces to the text and normalize if needed
        text_to_speak = gs
        if args.lang_code == 'a':
            text_to_speak = normalize_english_words(text_to_speak)
        padded_text = add_padding_spaces(text_to_speak)
        print("Text:", padded_text)
        print("Phonemes:", ps)
        
        # Generate audio with padded text
        pipeline = KPipeline(args.lang_code)
        generator_single = pipeline(padded_text, voice, args.speed, split_pattern=r'\n+')
        _, _, audio = next(generator_single)
        
        output_path = os.path.join(output_dir, f'{i}.wav')
        sf.write(output_path, audio, 24000)
        print(f"Saved as {output_path}")
        print()

if __name__ == "__main__":
    main()

