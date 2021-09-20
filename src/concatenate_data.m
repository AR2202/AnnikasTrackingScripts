function concatenated = concatenate_data(x, featnum, feat)
concatenated = [];
for i = 1:featnum
    concatenated = horzcat(concatenated, transpose(feat.data(x, :, i)));
end
end