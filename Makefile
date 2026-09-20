clean: clean-test clean-dist
clean-all: clean clean-cache
ot: offlinetest

.PHONY: clean clean-all clean-test clean-dist clean-cache \
        ot offlinetest codetest test \
        lazy-extractors

clean-test:
	rm -rf tmp/ *.annotations.xml *.aria2 *.description *.dump *.frag \
	*.frag.aria2 *.frag.urls *.info.json *.live_chat.json *.meta *.part* *.tmp *.temp *.unknown_video *.ytdl \
	*.3gp *.ape *.ass *.avi *.desktop *.f4v *.flac *.flv *.gif *.jpeg *.jpg *.lrc *.m4a *.m4v *.mhtml *.mkv *.mov *.mp3 *.mp4 \
	*.mpg *.mpga *.oga *.ogg *.opus *.png *.sbv *.srt *.ssa *.swf *.tt *.ttml *.url *.vtt *.wav *.webloc *.webm *.webp \
	test/testdata/sigs/player-*.js test/testdata/thumbnails/empty.webp "test/testdata/thumbnails/foo %d bar/foo_%d."*
clean-dist:
	rm -rf MANIFEST build/ dist/ .coverage cover/ \
	yt_dlp/extractor/lazy_extractors.py *.spec tyt-dlp tyt-dlp.exe yt_dlp.egg-info/
clean-cache:
	find . \( \
		-type d -name ".*_cache" -o -type d -name __pycache__ -o -name "*.pyc" -o -name "*.class" \
	\) -prune -exec rm -rf {} \;

lazy-extractors: yt_dlp/extractor/lazy_extractors.py

PYTHON ?= /usr/bin/env python3

codetest:
	ruff check .
	autopep8 --diff .

test:
	$(PYTHON) -m pytest -Werror
	$(MAKE) codetest

offlinetest: codetest
	$(PYTHON) -m pytest -Werror -m "not download"

_EXTRACTOR_FILES_CMD = find yt_dlp/extractor -name '*.py' -and -not -name 'lazy_extractors.py'
_EXTRACTOR_FILES != $(_EXTRACTOR_FILES_CMD)
_EXTRACTOR_FILES ?= $(shell $(_EXTRACTOR_FILES_CMD))
yt_dlp/extractor/lazy_extractors.py: devscripts/make_lazy_extractors.py devscripts/lazy_load_template.py $(_EXTRACTOR_FILES)
	$(PYTHON) devscripts/make_lazy_extractors.py $@
