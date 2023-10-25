% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_Module_ROI\Batch\Ace_Control_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
