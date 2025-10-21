clear; clc; close all;


%%    Load Function    %%

addpath(genpath('Function'));


%%    Image Index    %%

%%%%  Image Name  %%%%
% ImageName = 'Blurry3_11';
% ImageName = 'picassoBlurImage';
% ImageName = 'las_vegas_saturated';
% ImageName = 'flower_blurred';
% ImageName = 'IMG_4355_small';
% ImageName = 'scene002-3';
% ImageName = 'Blurry2_12';
ImageName = 'real_blur_img3';

%%%%  Read the Image  %%%%
Image_b = strcat( 'Test Image', '\', ImageName, '.png' );
b_RGB = im2double(imread(  Image_b  ));

[ Nx_b, Ny_b, ColorSize ] = size( b_RGB );

if ColorSize == 1
    b = b_RGB;
elseif ColorSize == 3
    b = rgb2gray( b_RGB );
else
    error( ' Error !!' )
end


%%    Parameter    %%

%%%%  Determine the number of candidates  %%%%
Num_Candidates = 5;

%%%%  Specify which candidate to use as the estimated kernel  %%%%
Idx_ug = 1;

%%%%  Load Parameter  %%%%
Table_Para = readcell( strcat( 'Parameter', '\', 'Table_Parameter', '.xlsx' ) );
Match      = find( contains(string(Table_Para), ImageName) );
Parameter  = Table_Para( [1, Match(1,1)], : );

%%%%  Kernel Size  %%%%
opts.Kernel_Size_est = Parameter{2,2};

%%%%  Calculate CPD  %%%%
opts.CPD_Sigma = Parameter{2,3};

%%%%  Non-Maximum Suppression: Sparse Weighting  %%%%
opts.NMS_Sparsity = Parameter{2,4};

%%%%  Connected Component Analysis  %%%%
opts.CCA_Scale = Parameter{2,5};
opts.CCA_ConnectType = Parameter{2,6};

%%%%  Resize Image and Candidates  %%%%
opts.Resize_Factor = Parameter{2,7};

%%%%  Spectrum Correlation  %%%%
opts.Corr_Sigma = Parameter{2,8};

%%%%  Non-Blind Deconvolution  %%%%
opts.Smooth_Blurred_Image = Parameter{2,9};
opts.Tikhonov_Factor = Parameter{2,10};
opts.ZeroFinding_Distance = Parameter{2,11};


%%    Create Folder    %%

opts.FolderName = strcat('Results', '\', ImageName );

if exist( opts.FolderName, 'file' ) == 0
    mkdir( opts.FolderName )
end


%%    Start Algorithm    %%

fprintf( 'Image: %s\n', ImageName )
fprintf( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n' )

%%%%  Kernel Estimation  %%%%
[ ug, u, RunTime, opts ] = f_00_Estimate_Kernel( b, opts, Num_Candidates, Idx_ug );

%%%%  Non-blind Deconvolution  %%%%
tic;
rg_RGB = f_00_Reconstruct_Image( b_RGB, ug, opts );
RunTime_1 = toc;

fprintf( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n' )
fprintf( 'Run Time (Estimate Kernel): %.1f s \n', sum(RunTime) )
fprintf( 'Run Time (Non-blind Deconvolution): %.1f s \n', RunTime_1 )
fprintf( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n' )


%%    Save Image    %%

%%%%  Kernel  %%%%
ug1 = ug  - min(ug(:));
ug1 = ug1 / max(ug1(:));
imwrite( ug1   , strcat( opts.FolderName,  '\', '00_Estimated Kernel', '.png' ) )
imwrite( b_RGB , strcat( opts.FolderName,  '\', '01_Blurred Image'   , '.png' ) )
imwrite( rg_RGB, strcat(  opts.FolderName, '\', '02_Deblurred Image' , '.png' ) )
% writematrix( round() )

figure( 1 )
    set( gcf, 'Position', [ 0 0 1800 800 ] )
    subplot( 1, 2, 1 )
        imshow( b_RGB )
    subplot( 1, 2, 2 )
        imshow( rg_RGB )
figure( 2 )
    imagesc( ug1 )
    axis square
    colormap gray


