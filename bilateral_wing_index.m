function bilat= bilateral_wing_index(inputfilename,flyid)
inputfilename_full=strcat(inputfilename,'-feat.mat');
 [bilat_wing_ext_frames_indexed]= bilateral_wing_ext(inputfilename_full);
  bilat=bilat_wing_ext_frames_indexed(bilat_wing_ext_frames_indexed(:,2)==flyid);