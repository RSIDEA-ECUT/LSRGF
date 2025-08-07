function normalized_matrix = Normalized(matrix)
    input_matrix = abs(matrix);
    Max_input = max(input_matrix(:));
    Min_input = min(input_matrix(:));
    min_matrix = ones(size(input_matrix)).*  Min_input;
    normalized_matrix = (input_matrix-min_matrix)./(Max_input-Min_input+eps);
end    