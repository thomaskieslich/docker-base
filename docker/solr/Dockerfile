ARG SOLR_VERSION

FROM solr:$SOLR_VERSION

COPY ./config/configsets/ /opt/solr/server/solr/configsets/
COPY ./config/solr.xml /opt/solr/server/solr/solr.xml