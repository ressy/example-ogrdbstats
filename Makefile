RPKGFILE = $(CONDA_PREFIX)/lib/R/library/ogrdbstats/DESCRIPTION
VERSION = 0.2.0

install: $(RPKGFILE)

$(RPKGFILE): ogrdbstats_$(VERSION).tar.gz
	R -e "install.packages('$<', repos=NULL, type='source')"

ogrdbstats_$(VERSION).tar.gz:
	wget https://github.com/airr-community/ogrdbstats/raw/master/$(notdir $@)

run: inf.VH.fasta IMGT_REF_GAPPED.fasta filtered.tab
	Rscript ogrdbstats/ogrdbstats.R --inf_file $(word 1,$^) $(word 2,$^) $(word 3,$^) VH

inf.VH.fasta: example-igdiscover/discovertest/final/filtered.tab.gz
	cp $(dir $<)/database/V.fasta $@

filtered.tab: example-igdiscover/discovertest/final/filtered.tab.gz
	zcat $< > $@

IMGT_REF_GAPPED.fasta:
	curl http://www.imgt.org/download/GENE-DB/IMGTGENEDB-ReferenceSequences.fasta-nt-WithGaps-F+ORF+inframeP | seqtk seq -l 0 > $@

# OR: ogrdbstats/testdata
example-igdiscover/discovertest/final/filtered.tab.gz:
	cd example-igdiscover && make
