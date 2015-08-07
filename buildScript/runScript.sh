#!/bin/sh


help() {
	echo "\nUSAGE: runScript.sh SRCROOT\nEXAMPLE: build iphone resources: runScript.sh my_proj_dir\n";
	exit 1;
}

buildImageMacros() {
	if [[ ! -d $GEN_DIR ]]; then
		mkdir -p $GEN_DIR
	fi

	IMAGE_DIR="${TARGET_PATH}/Resources/Images/"
	GEN_FILE="${GEN_DIR}/MXImageResources"
	TMP_FILE="${GEN_DIR}/tmp_MXImageResources"
	$SCRIPT_DIR/genImageMacros.py $IMAGE_DIR $TMP_FILE

	if [[ -f $GEN_FILE ]]; then
		diffCon=`diff ${GEN_FILE}.h ${TMP_FILE}.h`
		if [[ "$diffCon" != "" ]]; then
			#echo "file updated!"
			rm -f "${GEN_FILE}.h"
			mv -f "${TMP_FILE}.h" "${GEN_FILE}.h"
		else
			#echo "no change"
			rm -f "${TMP_FILE}.h"
		fi
	else
		mv -f "${TMP_FILE}.h" "${GEN_FILE}.h"
	fi

}


#############################################################
if [[ $# -lt 1 ]]; then
	help;
fi

SRCROOT=$1;
#TARGET_NAME=$2; #`echo $2 | tr '[A-Z]' '[a-z]'`

TARGET_PATH="${SRCROOT}"
GEN_DIR="${TARGET_PATH}/autoGen"
SCRIPT_DIR="${SRCROOT}/buildScript"

buildImageMacros;
