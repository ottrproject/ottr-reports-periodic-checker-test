# Container image that runs your code
FROM jhudsl/course_template:main
COPY entrypoint.sh /entrypoint.sh
WORKDIR /github/workspace
ENV PASSWORD=1234
USER root
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
