pkg load image;
##
##% Load gambar
##img = imread('D:\gambar\bangunan.jpeg');
##
##% Parameter transformasi
##theta = 30;           % Rotasi (derajat)
##scale = 0.8;          % Skala
##tx = 100;             % Translasi X
##ty = 50;              % Translasi Y
##theta_rad = deg2rad(theta);
##
##% Matriks transformasi affine
##T = [ scale * cos(theta_rad), -scale * sin(theta_rad), 0;
##      scale * sin(theta_rad),  scale * cos(theta_rad), 0;
##      tx,                     ty,                      1 ];
##
##% Ubah ke format yang bisa digunakan oleh imtransform
##Tform = maketform('affine', T);
##
##% Terapkan transformasi
##output = imtransform(img, Tform, 'bilinear');
##
##% Tampilkan hasil
##figure;
##subplot(1, 2, 1);
##imshow(img);
##title('Gambar Asli');
##
##subplot(1, 2, 2);
##imshow(output);
##title('Hasil Transformasi Affine');

% Baca citra dan konversi ke grayscale
F = rgb2gray(imread('D:\gambar\bangunan.jpeg'));

% Definisikan fungsi taffine
function G = taffine(F, a11, a12, a21, a22, tx, ty)
  % TAFFINE Digunakan untuk melakukan transformasi affine.
  % Masukan: F = Citra berskala keabuan
  % a11, a12, a21, a22, tx, ty = parameter transformasi affine

  % Inisialisasi matriks G dengan ukuran yang sama dengan F
  [tinggi, lebar] = size(F);
  G = zeros(tinggi, lebar);

  % Iterasi untuk setiap piksel
  for y = 1:tinggi
    for x = 1:lebar
      % Hitung koordinat baru
      x2 = round(a11 * x + a12 * y + tx);
      y2 = round(a21 * x + a22 * y + ty);

      % Periksa apakah koordinat baru berada dalam batas citra
      if (x2 >= 1) && (x2 <= lebar) && (y2 >= 1) && (y2 <= tinggi)
        % Lakukan interpolasi bilinear
        p = floor(y2);
        q = floor(x2);
        a = y2 - p;
        b = x2 - q;

        if (p == tinggi) || (q == lebar)
          G(y, x) = F(min(p, tinggi), min(q, lebar));
        else
          intensitas = (1-a)*((1-b)*double(F(p,q)) + b*double(F(p, q+1))) + ...
                       a *((1-b)* double(F(p+1, q)) + b * double(F(p+1, q+1)));
          G(y, x) = uint8(intensitas);
        end
      else
        G(y, x) = 0;
      end
    end
  end

  % Pastikan G dalam format uint8
  G = uint8(G);
endfunction

% Tentukan sudut rotasi dalam radian
rad = pi/4; % Contoh sudut 45 derajat

% Penggunaan fungsi
G = taffine(F, 2 * cos(rad), sin(rad), -sin(rad), 2 * cos(rad), -30, -50);

% Tampilkan hasil

subplot(1,2,1); imshow (F); title ('citra asli');
subplot(1,2,2); imshow (G); title ('affine');
