FROM pandoc/latex:edge
RUN tlmgr update --self --all
RUN tlmgr install roboto
RUN tlmgr install fontaxes
RUN tlmgr install sectsty
RUN tlmgr install wrapfig
RUN tlmgr install everypage
RUN tlmgr install tikzpagenodes
RUN tlmgr install ifoddpage
RUN apk add git
ADD entrypoint.sh /data/entrypoint.sh
ENTRYPOINT ["/data/entrypoint.sh"]
# RUN tlmgr install collection-fontsrecommended
