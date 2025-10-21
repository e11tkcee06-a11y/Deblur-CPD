function r_out = f_00_Reconstruct_Image( b_in, h, opts )


    %%    Parameter    %%
    
    %%%%  Global  %%%%
    kH = opts.Tikhonov_Factor;
    
    
    %%    Read the Image    %%
    
	[ Nx_b, Ny_b, ColorSize ] = size( b_in );
    [ Nx_h, Ny_h, ~ ] = size( h );
    
    if ColorSize == 1
        b = b_in;
    elseif ColorSize == 3
        b_YCbCr = rgb2ycbcr( b_in );
        b  = b_YCbCr(:,:,1);
        Cb = b_YCbCr(:,:,2);
        Cr = b_YCbCr(:,:,3);
    else
        error( 'Error Occur!!  \n' )
    end
    
    
    %%    Image Size    %%
    
    Nx_bh = Nx_b+Nx_h-1;
    Ny_bh = Ny_b+Ny_h-1;

    
    %%    Padding    %%
    
    %%%%  Blurred Image  %%%%
    b1 = wrap_boundary_liu(  b, [ Nx_bh, Ny_bh ]  );

    %%%%  Kernel  %%%%
    h1 = padarray( h, [ floor(Nx_b/2), floor(Ny_b/2) ], 'Both' );
    h1 = h1( 1:Nx_bh, 1:Ny_bh );
    
    %%%%  Center to Upper-left  %%%%
    h1 = ifftshift( h1 );
    
    
    %%    FFT    %%
    
    %%%%  Blurred Image  %%%%
    B1 = fft2(b1);
    B1_shift = fftshift( B1 );

    %%%%  Kernel  %%%%
    H1 = fft2(h1);
    H1_shift = fftshift(H1);
    
    
    %%    Reconstruct Image    %%
    
    %%%%  Inverse Term  %%%%
    Inverse = 1 ./ H1_shift;
   
    %%%%  Revised Filter Weighting  %%%%
    absH1_shift = abs( H1_shift );
    Weighting = absH1_shift.^2 ./ (  absH1_shift.^2 + kH  );

    Filter = Inverse .* Weighting;
    
    %%%%  Reconstruction  %%%%
	switch opts.Smooth_Blurred_Image
        case 'N'
            R1_shift = Filter .* B1_shift;

        case 'Y'
            b_smooth = f_Gaussian_Smoothing( b, opts.CPD_Sigma );
            b_smooth1 = wrap_boundary_liu(  b_smooth, [ Nx_bh, Ny_bh ]  );
            B_smooth1 = fft2( b_smooth1 );
            B_smooth1_shift = fftshift( B_smooth1 );

            R1_shift = Filter .* B_smooth1_shift;
	end
    
    %%%%  Zero Finding  %%%%
    ZeroMask = f_Zero_Finding( H1_shift, opts );

    %%%%  Periodic Noise Removal  %%%%
    R1_shift = f_Periodic_Noise_Removal( ZeroMask, R1_shift, opts );
    
    %%%%  Shifting  %%%%
    R1 = ifftshift( R1_shift );

    %%%%  IFFT  %%%%
    r1 = real(ifft2( R1 ));
    
    r2 = r1(1:Nx_b,1:Ny_b);
    
    if ColorSize == 1
        r_out = r2;
    elseif ColorSize == 3
        r_YCbCr = cat( 3, r2, Cb, Cr );
        r_out = ycbcr2rgb( r_YCbCr );
    else
        error( 'Error Occur!! \n' )
    end
    
    
end


