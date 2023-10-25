%-----------------------------------------------------------------------
% Job saved on 11-Feb-2020 21:55:07 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_ROI\TST_NAc.nii,1'
                                        'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_ROI\TST_Caudate.nii,1'
                                        'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_ROI\TST_Putamen.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'TST_Approach';
matlabbatch{1}.spm.util.imcalc.outdir = {'D:\JM_Neo_BART\TST_Ace_Analyses\TST_Ace_Module_ROI'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1+i2+i3';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
