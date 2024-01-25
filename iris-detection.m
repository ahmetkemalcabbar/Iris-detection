img = 'example1.jpg';
output_directory = '/';

task1(img, 125, 360, output_directory);

    
function task1(url_of_input_image, min_radius, max_radius, directory_url_of_output_images)
    
    % url_of_input_image: Giriş görüntüsünün dosya yolu
    % min_radius: Minimum çember yarıçapı
    % max_radius: Maximum çember yarıçapı
    % directory_url_of_output_images: Çıktı görüntülerinin kaydedileceği dizin

    % First we'll convert rgb image to 8-bit gray-level image
    input_image = imread(url_of_input_image);

    r = double(input_image(:,:,1)) / 255;
    g = double(input_image(:,:,2)) / 255;
    b = double(input_image(:,:,3)) / 255;

    grey_image = (r + g + b) / 3;

    sigma = 3;
    filtered_img = imgaussfilt(grey_image, sigma);


    BW = edge(filtered_img,'canny');

    % Circular Hough Transform
    [center_iris, r_iris] = myHoughCircleTransform(BW, min_radius, min_radius+20);
    [center_pupil, r_pupil] = myHoughCircleTransform(BW, max_radius-20, max_radius);

    center = center_iris;

    % display iris and pupil circles on original image
    showCircules(input_image, center, r_iris, r_pupil);

    % Daugman rubber Sheet Modal
    %unwrapped_image = mydaugmanRubberSheet(input_image,center,r_iris,r_pupil);

    %imshow(unwrapped_image)

    % saving output image
    %saveImage(unwrapped_image, directory_url_of_output_images)


    function [centers, radii] = myHoughCircleTransform(bin_image, minn, maxx)

        % Hough dönüşüm parametreleri
        theta = linspace(0, 360, 361);
        num_theta = length(theta);


        % Hough uzayı oluşturma
        hough_space = zeros(size(bin_image, 1), size(bin_image, 2),maxx);
        disp(size(hough_space))


        % Hough dönüşümü
        for x = 1:size(bin_image, 1)
            for y = 1:size(bin_image, 2)
                if bin_image(x, y) > 0 % Eğer kenar pikseli ise
                    for rad = minn:maxx
                        for k = 1:num_theta

                            a = round(x - rad*cos(theta(k)));
                            b = round(y + rad*sin(theta(k)));

                            if a > 0 && a <= size(bin_image, 1) && b > 0 && b <= size(bin_image, 2)
                                hough_space(a, b, rad) = hough_space(a, b, rad) + 1;
                            end
                        end
                    end
                end
            end
        end

        % Maksimum değeri ve indisini bulma
        [max_value, indices] = maxk(hough_space(:), 1);

        [a, b, r] = ind2sub(size(hough_space), indices);


        % Çemberin merkezini ve yarıçapını kaydetme
        centers = [b, a];
        disp(centers)
        radii = r;


    end

    function showCircules(input_image, center, r_iris, r_pupil)
        % Çemberi orijinal resim üzerine çizme
        output_image = insertShape(input_image, 'circle', [center, r_iris], 'Color', 'red');
        output_image = insertShape(output_image, 'circle', [center, r_pupil], 'Color', 'blue');
    
        % Orijinal ve çizilmiş resimleri gösterme
        imshow(output_image, 'InitialMagnification', 'fit');
    end
    
    function unwrapped_image = mydaugmanRubberSheet(image,center,r_iris,r_pupil)
        r_in = r_iris;
        r_out = r_pupil;

        %theta range
        theta_range = linspace(0.5, 360, 721);
        num_theta = length(theta_range);

        % size of unwrapped image
        width = num_theta;
        height = round(r_out - r_in);

        % Initialize unwrapped image
        if size(image, 3) == 3
            unwrapped_image = uint8(zeros(height, width, 3));
        else
            unwrapped_image = zeros(height, width, 1);
        end

        % coordinates of center(x, y)
        merkez_x = center(1);
        merkez_y = center(2);

        % Iterate over each pixel in the unwrapped image
        for i = 1:width % num of theta (722)
            for j = 1:height % r_out - r_in

                theta = theta_range(i);

                Xi = merkez_x + (r_in + j) * cosd(theta);
                Yi = merkez_y + (r_in + j) * sind(theta);

                Xi = floor(Xi);
                Yi = floor(Yi);

                % Eğer indeks matrisin boyutlarını aşıyorsa kontrol
                if j <= size(image, 1) && i <= size(image, 2)
                    color = image(Yi, Xi,:);
                else
                    color = [255,255,255];
                end

                unwrapped_image(j,i,:) = color;

            end
        end

        %unwrapped_image = removeWhitePixels(unwrapped_image);
    end

    function saveImage(output_image, output_directory)

        output_filename_color = 'output_image.ppm';
        output_filename_grey = 'output_image.pgm';


        % Kaydedilecek dosya adı ve uzantısı
        output_fullpath_color = fullfile(output_directory, output_filename_color);
        imwrite(output_image, output_fullpath_color);

        output_fullpath_grey = fullfile(output_directory, output_filename_grey);
        imwrite(output_image, output_fullpath_grey);
    end
    
end