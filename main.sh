rm -rf data/*

for zip in ALK-Extract/selected-benchmarks/*.zip; do
	unzip -o $zip -d data
done

rm -rf data/__MACOSX

for file in data/*.cnf; do
	cnf2knf --grid=true -Write_KNF data/$(basename -- $file .cnf).hier.knf $file
	knf2cnf data/$(basename -- $file .cnf).hier.knf > data/$(basename -- $file .cnf).hier.cnf
	satsuma lex --knf data/$(basename -- $file .cnf).hier.knf > data/$(basename -- $file .cnf).hier.lex.knf
	knf2cnf data/$(basename -- $file .cnf).hier.lex.knf > data/$(basename -- $file .cnf).hier.lex.cnf

	cnf2knf --grid=false -Write_KNF data/$(basename -- $file .cnf).grid.knf $file
	knf2cnf data/$(basename -- $file .cnf).grid.knf > data/$(basename -- $file .cnf).grid.cnf
	satsuma lex --knf data/$(basename -- $file .cnf).grid.knf > data/$(basename -- $file .cnf).grid.lex.knf
	knf2cnf data/$(basename -- $file .cnf).grid.lex.knf > data/$(basename -- $file .cnf).grid.lex.cnf
done

TIMEOUT=10000

for file in data/*.cnf; do
	cadical -t $TIMEOUT $file > data/$(basename -- $file .cnf).log
done

grep ^s ./data/*.log > data/solution.out
grep resources -A 5 ./data/*.log > data/resources.out
