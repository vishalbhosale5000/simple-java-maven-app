#!/bin/bash
webhook_commit_id=$commit
commit_by_jenkins=commit_by_jenkins.txt
if [ ! -f $commit_by_jenkins ]
then
    echo "creating local file name commit_by_jenkins.txt, please add this file to git ignore"
    touch commit_by_jenkins.txt
fi
jenkins_commit=`cat commit_by_jenkins.txt`
if [ "${webhook_commit_id}" == "${jenkins_commit}" ]; then 
    echo "commit by jekins server, ignoring commit"
else
      echo "commiting code from jenkins servver"
      git add -A && git commit -m "commit by jenkins server" && git rev-parse HEAD > commit_by_jenkins.txt
fi
