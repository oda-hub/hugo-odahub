publish: import
	( \
		hugo; \
		cd public/; \
		mkdir -pv ontology; \
		cat ../../renku/owl-doc/odaowl-static.html > ontology/index.html; \
		cat ../../renku/owl-doc/rdf.ttl > ontology/rdf.ttl; \
		rsync -avu ../../renku/owl-doc/lode ontology/lode; \
		mkdir -pv ontology-respec; \
		cat ../source/odahub-respec/spec.html > ontology-respec/index.html; \
		cat ../source/odahub-respec/rdf > ontology-respec/rdf; \
	       	git add *; \
		git commit -a -m "update"; \
		git push)


import:
	cat source/workflow-discovery/README.md > content/docs/guide-discovery.md 
	cat source/workflow-discovery/README.md > content/_index.md
	cat source/doc-issue-handling-workflow/README.md > content/docs/issues.md
	cat source/guide-to-create-workflows/README.md > content/docs/guide-development.md

