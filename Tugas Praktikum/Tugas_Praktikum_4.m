% TUGAS PRAKTIKUM 4 %

% Memuat package image
pkg load image;

% Membaca citra
img = imread('D:\gambar\mobil.jpg');

% Tentukan parameter efek twirl
% center_x, center_y: Pusat putaran (biasanya di tengah citra)
% angle: Sudut putaran dalam radian.
%   - Positif untuk putaran searah jarum jam
%   - Negatif untuk putaran berlawanan arah jarum jam
% radius: Radius area yang akan diputar. Piksel di luar radius ini tidak akan terpengaruh.
[rows, cols, ~] = size(img);
center_x = cols / 2;
center_y = rows / 2;
angle = 0.5 * pi; % Putar 90 derajat searah jarum jam (pi/2 radian)
radius = min(rows, cols) / 2; % Setengah dari dimensi citra terkecil sebagai radius

% Inisialisasi citra output
img_twirled = zeros(rows, cols, size(img, 3), class(img));

% Menerapkan efek twirl
for y = 1:rows
    for x = 1:cols
        % Hitung koordinat relatif dari pusat
        dx = x - center_x;
        dy = y - center_y;

        % Hitung jarak dari pusat dan sudut
        distance = sqrt(dx^2 + dy^2);
        current_angle = atan2(dy, dx); % Sudut asli piksel

        % Hanya putar piksel dalam radius yang ditentukan
        if distance < radius
            % Hitung faktor putaran berdasarkan jarak dari pusat
            % Semakin dekat ke pusat, semakin besar putarannya
            % Semakin jauh (tapi masih dalam radius), putaran berkurang secara linier
            percent = (radius - distance) / radius;

            % Tambahkan sudut putaran yang dimodifikasi
            new_angle = current_angle + angle * percent;

            % Konversi kembali ke koordinat kartesius yang baru
            new_x = center_x + distance * cos(new_angle);
            new_y = center_y + distance * sin(new_angle);
        else
            % Piksel di luar radius tidak diputar
            new_x = x;
            new_y = y;
        end

        % Pastikan koordinat sumber berada dalam batas citra input
        source_x = round(new_x);
        source_y = round(new_y);
        source_x = max(1, min(source_x, cols));
        source_y = max(1, min(source_y, rows));

        % Ambil nilai piksel dari citra sumber (menggunakan interpolasi nearest-neighbor)
        img_twirled(y, x, :) = img(source_y, source_x, :);
    end
end

% Menampilkan hasil
figure;
subplot(1, 2, 1); imshow(img); title('Citra Asli');
subplot(1, 2, 2); imshow(img_twirled); title(sprintf('Efek Twirl (%.0f derajat)', rad2deg(angle)));
