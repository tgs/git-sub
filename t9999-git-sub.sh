#!/bin/bash


test_description="git sub"
#. ./test-lib.sh
. ./lib-git-svn.sh

test_expect_success 'setup git-svn' '
	svnadmin load "$rawsvnrepo" < ${TEST_DIRECTORY}/t9999/svn.dump
	git svn init "$svnrepo"
	git svn fetch
'

test_expect_success 'git sub commit-from-svn' '
	# wtf wtf wtf wtf???
	false
	#test_must_fail git sub read-note-pointer refs/remotes/git-svn^^
	git sub commit-from-svn refs/remotes/git-svn^^
	#git sub read-note-pointer from-svn
	#git sub read-note-pointer refs/remotes/git-svn^^
	false
	FIRST=`git rev-parse from-svn`
	test -n "$FIRST"
	git sub commit-from-svn refs/remotes/git-svn^
	SECOND=`git rev-parse from-svn`
	test -n "$SECOND"
	#test "$FIRST" = `git rev-parse from-svn^`
'

test_expect_failure 'git sub init' '
	git svn info
	git sub init
	git branch -a | grep for-svn
	NUM_DISTINCT=$(git rev-parse refs/remotes/git-svn from-svn for-svn | sort | uniq | wc -l)
	test 2 -eq "$NUM_DISTINCT"
'

test_expect_success 'git sub unknown command' '
	test_must_fail git sub blahblah foo
'

test_done

