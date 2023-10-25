%-----------------------------------------------------------------------
% Job saved on 11-Feb-2020 21:57:05 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_ROI\TST_Amygdala.nii,1'
                                        'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_ROI\TST_Insula.nii,1'
                                        'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_ROI\TST_Hippocampus.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'TST_Avoidance';
matlabbatch{1}.spm.util.imcalc.outdir = {'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_Module_ROI'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1+i2+i3';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
