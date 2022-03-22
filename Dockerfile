# Container image that runs your code
FROM jhudsl/course_template:main
COPY entrypoint.sh /entrypoint.sh
WORKDIR /github/workspace
USER rstudio
ENV PASSWORD=1234
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
