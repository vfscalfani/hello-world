
%% WoS_bib_CR_Freq = Web of Science (Clarivate Analytics) Article Bibliography
% Cited References Frequency

% Vincent F. Scalfani
% The University of Alabama 
% July 2, 2018
% v1.0

% Description:
%{
WoS_bib_CR_Freq is a small bibliometrics data analysis script that inputs
Web of Science BibTeX article bibliographic records and then counts the 
number of times each reference is cited (Cited-References field) 
within the inputed BibTeX file.
%}


%% 1. Input "Full Record and Cited References" WoS BibTex file. 

% change directory
cd('H:\Documents\MATLAB\Bibliometrics\WoS Cited Refs Analysis');

% read BibTeX Data file into Matlab as a character array
bibtex_char = fileread('UA_Author_CR_Data.txt');
    
% replace tags with "Number-of-Cited-References = {{0}}," with "ignore"
bibtex_char = strrep(bibtex_char, 'Number-of-Cited-References = {{0}},', 'ignore');

%% 2. Extract out all data within each "Cited-References" field. 

% Extract Cited References data
CR_cell = extractBetween(bibtex_char, 'Cited-References = {{', 'Number-of-Cited-References');
    
% split cited references into one on each line
CR_cell = cellfun(@(newline) strsplit(newline, '\n'), CR_cell, 'UniformOutput', false);
    
% reposition split values into individual cells
CR_cell = [CR_cell{:}];
CR_cell = CR_cell';

%% 3. Extract out only the Journal/Reference Title from result in step 2.

% now split at comma delimiter
CR_cell_s = cellfun(@(comma) strsplit(comma, ','), CR_cell, 'UniformOutput', false);
   
% delete 1 x 1 cells (incomplete, non-standard citations)
one = cellfun(@numel, CR_cell_s);
CR_cell_s(one==1) = [];

% delete 1 x 2 cells (incomplete, non-standard citations)
two = cellfun(@numel, CR_cell_s);
CR_cell_s(two==2) = [];

% extract 3rd column with Journal/Reference Title
extract_3c = 3;
CR_cell_sJournals = cellfun(@(x) x(extract_3c), CR_cell_s);

% data cleanup
% delete periods
CR_cell_sJournals = erase(CR_cell_sJournals, ".");

% delete leading blank character
CR_cell_sJournals = strip(CR_cell_sJournals, 'left');

%% 4. Calculate frequency of Journal/Reference Titles and sort.

% calculate Freq table
freq_Journals = tabulate(CR_cell_sJournals);
sort_freq_Journals = sortrows(freq_Journals,2, 'descend');

% convert to table
sort_freq_Journals_T = cell2table(sort_freq_Journals, 'VariableNames', {'Journal_Uniq', 'Freq_Number', 'Freq_Percent'});

% display top 25 results
disp('Top 25 cited below, full data in sort_freq_Journals_T table')
Top25 = head(sort_freq_Journals_T, 25)


%% 5. write all results to csv file

%writetable(sort_freq_Journals_T, 'freq_CR_Data.txt');






