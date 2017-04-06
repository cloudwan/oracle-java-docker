set -eu

case "${ORACLE_JAVA_INSTALL_VERBOSE}" in
[Yy][Ee][Ss]|[Tt][Rr][Uu][Ee]|[Oo][Nn])
	set -x
	;;
esac

# rm_safe < pathnames
#
# Read pathnames (files and directories) from stdin and remove them.
#
# Use rmdir, and not rm -rf, to remove a directory; remove depth-first, so that
# if a directory as well as all its descendants are listed, by the time the
# directory is to be rmdir-ed, the directory is empty.  If some descendants of a
# directory is not listed, the rmdir will fail (hence "safe").

rm_safe() {
	local pathname
	sort -rt/ | \
	while read -r pathname
	do
		if [ -d "${pathname}" -a ! -L "${pathname}" ]
		then
			rmdir "${pathname}"
		else
			rm -f "${pathname}"
		fi
	done
}

# find_orphaned_files_in dir ...
#
# Print all files under the given directory/-ies that do not belong to any
# package ("orphaned").

find_orphaned_files_in() {
	find "$@" -print0 | \
		xargs -0 dpkg-query -S 2>&1 > /dev/null | \
		sed -n 's#^dpkg-query: no path found matching pattern ##p'
}

# We need to add the Oracle Java PPA, using add-apt-repository from the
# software-properties-common package.
#
# ca-certificates is for verifying HTTPS download of Java installer packages.
#
# Install these two packages temporarily, and auto-purge them when finished.
# If for some reason the Java installer packages starts depending on them, they
# should not be purged, hence auto-purge.

apt-get update -y	# for software-properties-common
apt-get install -y software-properties-common ca-certificates
add-apt-repository ppa:webupd8team/java
apt-get update -y	# for the Oracle Java PPA
yes | apt-get install -y \
	oracle-java8-installer \
	oracle-java8-unlimited-jce-policy
apt-mark auto software-properties-common ca-certificates
apt-get autoremove -y --purge

# The Java installer keeps downloaded files in a cache directory; remove them.
# Remove only the files that do not belong to any packages, as some files in the
# cache directory belong to the Java installer package itself.

find_orphaned_files_in /var/cache/oracle-jdk8-installer | rm_safe
