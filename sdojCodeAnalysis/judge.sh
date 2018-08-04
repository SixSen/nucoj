#!/bin/bash

# current workdir is /home/hwf/onlineJudge/myCode
# target workdir is /home/hwf/onlineJudge/judge

# what is judeg??
cp judge ../judge/judge

# use "--cap-add=SYS_PTRACE" so that ptrace can be used in Docker
#            1      2     3    4      5         6         7      8      9
#         workdir runId, cid, pno, language, hostname username passwd dbname
docker run --rm --cap-add=SYS_PTRACE -u oj -v $1:/judge ubuntu:oj bin/bash -c "cd /judge && ./judge $2 $3 $4 $5 $6 $7 $8 $9"

