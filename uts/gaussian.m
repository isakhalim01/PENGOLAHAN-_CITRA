pkg load image;

% Membaca gambar
img = imread('D:\gambar\dalan.jpg');

% Konversi ke grayscale jika RGB
if ndims(img) == 3
  img = rgb2gray(img);
endif

% Buat filter Gaussian
sigma = 2; % Standar deviasi Gaussian (semakin besar, semakin blur)
kernel_size = 2 * ceil(3 * sigma) + 1; % Ukuran kernel berdasarkan sigma
h = fspecial('gaussian', kernel_size, sigma); % Buat kernel Gaussian

% Terapkan filter ke gambar
blurred_img = imfilter(img, h, 'replicate');

% Tampilkan hasil
figure;
subplot(1,2,1), imshow(img), title('Asli');
subplot(1,2,2), imshow(blurred_img), title('Gaussian Blur');

