RPKGFILE = $(CONDA_PREFIX)/lib/R/library/ogrdbstats/DESCRIPTION
VERSION = 0.2.0
SPECIES = Homosapiens
REF_URL = http://www.imgt.org/download/GENE-DB/IMGTGENEDB-ReferenceSequences.fasta-nt-WithGaps-F+ORF+inframeP

run: filtered_ogrdb_report.csv

filtered_ogrdb_report.csv: ogrdbstats/testdata/JH_igdiscover/J.fasta IMGT_REF_GAPPED.fasta ogrdbstats/testdata/JH_igdiscover/filtered.tab $(RPKGFILE)
	Rscript ogrdbstats/ogrdbstats.R --inf_file $(word 1,$^) $(word 2,$^) $(SPECIES) $(word 3,$^) JH

install: $(RPKGFILE)

$(RPKGFILE): ogrdbstats_$(VERSION).tar.gz
	R -e "install.packages('$<', repos=NULL, type='source')"

# Version 0.2.0 crashes with the example IgDiscover JH files
#ogrdbstats_$(VERSION).tar.gz:
#	wget https://github.com/airr-community/ogrdbstats/raw/master/$(notdir $@)
ogrdbstats_$(VERSION).tar.gz:
	R CMD build ogrdbstats

IMGT_REF_GAPPED.fasta:
	curl $(REF_URL) > $@

clean:
	rm -f filtered.tab
	rm -f filtered_ogrdb_plots.pdf
	rm -f filtered_ogrdb_report.csv

realclean: clean
	rm -f ogrdbstats_*.tar.gz
	rm -f *.fasta
