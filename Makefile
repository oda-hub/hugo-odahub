publish: import
	(hugo; cd public/; mkdir -pv ontology; cat ../source/odahub-respec/spec.html > ontology/index.html;  git add *; git commit -a -m "update"; git push)

import:
	cat source/workflow-discovery/README.md > content/docs/guide-discovery.md 
	cat source/workflow-discovery/README.md > content/_index.md
	cat source/doc-issue-handling-workflow/README.md > content/docs/issues.md
	cat source/guide-to-create-workflows/README.md > content/docs/guide-development.md

