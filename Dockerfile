FROM pandoc/latex:edge
RUN tlmgr update --all
RUN tlmgr install roboto
RUN tlmgr install fontaxes
RUN tlmgr install sectsty
RUN tlmgr install wrapfig
RUN tlmgr install everypage
RUN tlmgr install tikzpagenodes
RUN tlmgr install ifoddpage
ADD entrypoint.sh /data/entrypoint.sh
RUN apk add git
ENTRYPOINT ["/data/entrypoint.sh"]
# RUN tlmgr install collection-fontsrecommended
