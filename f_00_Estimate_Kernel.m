function [ ug, u1, RunTime, opts ] = f_00_Estimate_Kernel( b, opts, Num_Candidates, Index_ug )


    %%    Main Function Description    %%

    %%%%  Summary  %%%%
    % This main function is used to estimate the kernel from the CPD image
    % of the input blurred image. There are six steps:
    
    % 01__Find the matched CPD peaks of the input blurred image.
    % 02__Produce masks based on the matched CPD peaks.
    % 03__Perform connected component analysis on the masks to obtain initial positive and negative candidates.
    % 04__Center, normalize and merge initial candidates to obtain refined candidates
    % 05__Resize input blurred image and candidates.
    % 06__Calculate spectrum correlation between resized input blurredn image and the candidates.
    
    % After the above six steps, we can get the estimated kernel.
    
    %%%%  Input  %%%%
    % b             : Input Blurred Image
    % opts          : Global Parameters
    % Num_Candidates: Number of Kernel Candidates
    % Index_ug      : Candidate Index
    
    %%%%  Output  %%%%
    % ug      : Output Estimated Kernel
    % u1      : All Candidates
    % RunTime : Run Time
    % opts    : Global Parameters


    %%    01__Matched CPD Peaks of Blurred Image    %%
    
    fprintf( ' 01__Matched CPD Peaks of Blurred Image__' )
    tic;

    [ bxy_P, bxy_N, Harris_b, bxy_P_MatchPeak, bxy_P_MatchHarris, bxy_N_MatchPeak, bxy_N_MatchHarris ] = f_01_Matched_Peaks( b, opts );
    
    RunTime(1,1) = toc;
    fprintf( '%.4f s..........', RunTime(1,1) )
    fprintf( 2, ' Done! \n' )


    %%    02__Produce Masks    %%

    fprintf( ' 02__Produce Masks__' )
    tic;

    Mask_P = f_02_Produce_Masks( bxy_P, bxy_P_MatchPeak, opts );
	Mask_N = f_02_Produce_Masks( bxy_N, bxy_N_MatchPeak, opts );

    Num_Mask_P = size( Mask_P,3 );
    Num_Mask_N = size( Mask_N,3 );

    RunTime(1,2) = toc;
    fprintf( '%.4f s..........', RunTime(1,2) )
    fprintf( 2, ' Done! \n' )


    %%    03__Connected Component Analysis    %%

    fprintf( ' 03__Connected Component Analysis__' )
    tic;

    %%%%  Positive  %%%%
    Mask_Decomposition_P = cell( Num_Mask_P, 1 );
    for h = 1 : 1 : Num_Mask_P
        Mask_Decomposition_P{ h, 1 } = f_03_Connected_Component_Analysis( Mask_P(:,:,h), opts );
    end
    uP = cat( 3, Mask_Decomposition_P{:,1} );

    %%%%  Negative  %%%%
    Mask_Decomposition_N = cell( Num_Mask_N, 1 );
    for h = 1 : 1 : Num_Mask_N
        Mask_Decomposition_N{ h, 1 } = f_03_Connected_Component_Analysis( Mask_N(:,:,h), opts );
    end
    uN = cat( 3, Mask_Decomposition_N{:,1} );

    RunTime(1,3) = toc;
    fprintf( '%.4f s..........', RunTime(1,3) )
    fprintf( 2, ' Done! \n' )


    %%    04__Center, Normalize and Merge Candidates    %%

    fprintf( ' 04__Center and Normalize Candidates__' )
    tic;

    uP1 = f_04_Adjust_PSF_Center( uP, opts );
    uN1 = f_04_Adjust_PSF_Center( uN, opts );

    %%%%  Combine  %%%%
    u0 = cat( 3, uP1, uN1 );

    RunTime(1,4) = toc;
    fprintf( '%.4f s..........', RunTime(1,4) )
    fprintf( 2, ' Done! \n' )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for Hide___Fig_04___Connected_Component_Analysis = 1 : 0
        
        Num_u0 = size( u0, 3 );
        
        figure( 04 )
            set( gcf, 'Position', [ 0 0 1800 900 ] )
            for h = 1 : 1 : Num_u0

                Plot_u0 = u0(:,:,h);
                Plot_u0 = Plot_u0 - min(min(Plot_u0));
                Plot_u0 = Plot_u0 / max(max(Plot_u0));

                subplot( ceil(Num_u0/10), 10, h )
                    imshow( Plot_u0, [] )

            end
            
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%    05__Resize Image and Candidates    %%

    fprintf( ' 05__Resired_Candidates__' )
    tic;

    %%%%  Resize Blurred Image  %%%%
	sb = imresize( b, opts.Resize_Factor );

    %%%%  Resize Candidates  %%%%
    su0 = imresize( u0, opts.Resize_Factor );
    su0 = su0 ./ sum(sum(su0));

    RunTime(1,5) = toc;
    fprintf( '%.4f s..........', RunTime(1,5) )
    fprintf( 2, ' Done! \n' )


    %%    06__Spectrum Correlation    %%

    fprintf( ' 06__Spectrum Correlation__' )
    tic;

    [ sB_Log, sU0_Log, CORR ] = f_06_Spectrum_Correlation( sb, su0, opts );

    Num_Desired = min( size(su0,3), Num_Candidates );

    u1      = u0( :,:,CORR( 1:Num_Desired, 1) );
    sU1_Log = sU0_Log( :,:,CORR( 1:Num_Desired, 1) );

    Num_u1 = size( u1, 3 );
    
    ug = u1(:,:,Index_ug);

    RunTime(1,6) = toc;
    fprintf( '%.4f s..........', RunTime(1,6) )
    fprintf( 2, ' Done! \n' )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for Hide___Fig_06_0___Spectrum_Blurred_Image = 1 : 0

        Plot_sB_Log = sB_Log;
        Plot_sB_Log( Plot_sB_Log > 2 ) = 2;

        Plot_sB_Log = Plot_sB_Log - min(min(Plot_sB_Log));
        Plot_sB_Log = Plot_sB_Log / max(max(Plot_sB_Log));

        figure( 06 )
            imshow( Plot_sB_Log )

    end
    for Hide___Fig_06_1___Candidates = 1 : 0
        figure( 16 )
            set( gcf, 'Position', [ 0 0 1800 900 ] )
            for h = 1 : 1 : Num_u1

                Plot_u1 = u1(:,:,h);
                Plot_u1 = Plot_u1 - min(min(Plot_u1));
                Plot_u1 = Plot_u1 / max(max(Plot_u1));

                subplot( ceil(Num_u1/5), 5, h )
                    imshow( Plot_u1 )
                    title( strcat( num2str(CORR(h,1),'%.2d'),'-',num2str(CORR(h,2),'%.4f') ), 'FontName', 'Times New Roman', 'FontSize', 16 )
            end
    end
    for Hide___Fig_06_2___Spectrum_Candidates_2D = 1 : 0
        figure( 26 )
            set( gcf, 'Position', [ 0 0 1800 900 ] )
            for h = 1 : 1 : Num_u1

                Plot_sU1_Log = sU1_Log(:,:,h);
                Plot_sU1_Log = Plot_sU1_Log - min(min(Plot_sU1_Log));
                Plot_sU1_Log = Plot_sU1_Log / max(max(Plot_sU1_Log));

                subplot( ceil(Num_u1/5), 5, h )
                    imshow( Plot_sU1_Log )
                    title( strcat( num2str(CORR(h,1),'%.2d'),'-',num2str(CORR(h,2),'%.4f') ), 'FontName', 'Times New Roman', 'FontSize', 16 )
            end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end




