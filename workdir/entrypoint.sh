#!/bin/sh

BUF_IMAGE_MASTER=${INPUT_CHECKOUTS_DIR}/master/buf.bin
PROTOS_MASTER=${INPUT_CHECKOUTS_DIR}/master
PROTOS_BRANCH=${INPUT_CHECKOUTS_DIR}/branch

# Build buf image of master branch
buf image build --source "${PROTOS_MASTER}" --output "${BUF_IMAGE_MASTER}"
exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo "Failed to build buf image of master"
  exit $exit_code
fi

# Lint check branch
output_lint=$(buf --input "${PROTOS_BRANCH}" check lint)
exit_lint=$?
echo "${output_lint}"

# Break check branch against above built buf image of master
output_break=$(buf check breaking --input "${PROTOS_BRANCH}" --against-input "${BUF_IMAGE_MASTER}")
exit_break=$?
echo "${output_break}"

if [ $exit_lint -ne 0 ] || [ $exit_break -ne 0 ]; then

  # Make a comment on the PR if enabled
  if [ "${INPUT_MAKE_PR_COMMENT}" = "true" ]; then
    comment=""
    if [ $exit_lint -ne 0 ]; then
      comment="#### Lint failed
\`\`\`
${output_lint}
\`\`\`"
    fi
    if [ $exit_break -ne 0 ]; then
      comment="$comment
#### Break check failed
\`\`\`
${output_break}
\`\`\`"
    fi
    comments_url=$(cat "${GITHUB_EVENT_PATH}" | jq -r .pull_request.comments_url)
    comment_json=$(echo "${comment}" | jq -R -s '{body: .}')
    echo "$comment_json"
    curl -s -S -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" -d "${comment_json}" "${comments_url}"
  fi

  exit 1 # If either linting or compatibility failed exit with an error.
else
  exit 0
fi

# Catch bugs in the script
echo "Unexpected exit"
exit 1
