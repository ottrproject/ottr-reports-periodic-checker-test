# Container image that runs your code
FROM jhudsl/course_template:main
COPY entrypoint.sh /entrypoint.sh
WORKDIR /github/workspace
USER rstudio
CMD ["/usr/lib/rstudio-server/bin/rserver","--server-daemonize=0","--auth-none=1"]
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
