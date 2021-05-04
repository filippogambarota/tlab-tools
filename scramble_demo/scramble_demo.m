%% General Info 

% You have to put all your functions to a folder or the root of your *.m matlab script
% Put all your images in a folder (just for organization purposes) let's say images/
% install the image processing toolbox in Matlab

%% Workspace

input_folder = "raw_images";
output_folder = "final_images";

%% Reading Images

[images, nimages, names] = read_all_images(input_folder, "jpg", 0); % reading all images (check the function)

%% Scramble

im_scrambled = cell(nimages, 1); % init the cell array
nscram = 10; % number of pieces

for im = 1:nimages
    im_scrambled{im} = scramble(images{im}, nscram);
end

%% Writing images
% you can do it on the previous loop of course

for im = 1:nimages
    imwrite(im_scrambled{im}, fullfile(output_folder, strcat(names{im})));
end