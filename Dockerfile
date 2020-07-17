FROM subugoe/muggle-onbuild:f60004c31979947dab53fbf9cfbb0e7f1c4bea55
COPY init.sh /usr/local/bin/
# TODO this can move inside of the copy command once that feature goes mainline in docker
RUN ["sh", "-c", "chmod u+x /usr/local/bin/init.sh"]
EXPOSE 80
