%   Input your image as a RGB image to this function, it will return the image
%   back with the spectacles on it.
%   Inputs
%   im = RGB image with N*M*3 dimensions
%   Outputs
%   thugIm = RGB image with N*M*3 dimensions with the spectacles on it,
%   NaN if eyes not detected.
function thugIm = thugLyf(im)

im = imresize(im,[369 NaN]);
%load the spectacle image and the mask
load spec



eyeDetector = vision.CascadeObjectDetector('EyePairSmall');
bbox = step(eyeDetector, im);
if numel(bbox) <1
    eyeDetector = vision.CascadeObjectDetector('EyePairBig');
    bbox = step(eyeDetector, im);
end

if numel(bbox) < 1
    thugIm = NaN;
    return;
end;
% shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
% I_faces = step(shapeInserter, im, int32(bbox));   
% figure, imshow(I_faces), title('Detected faces'); 

%Generate a bigger bounding box.
bboxnew(1) = round(bbox(1) - bbox(3)/8)
bboxnew(2) = round(bbox(2) - bbox(4)/10)
bboxnew(3) = round(bbox(3) + 2*(bbox(1) - bboxnew(1)))
bboxnew(4) = round(bbox(4) + 2*(bbox(2) - bboxnew(2)))


%apply the mask and the spectacle image on the image
im1 = im;
specr = imresize(specb,[bboxnew(4) bboxnew(3)]);
specrbin =~ imresize(specbin,[bboxnew(4) bboxnew(3)]);

tester = im1(bboxnew(2):bboxnew(2)+bboxnew(4)-1,bboxnew(1):bboxnew(1)+bboxnew(3)-1,1)
tester(tester&specrbin) = specr(tester&specrbin)
im1(bboxnew(2):bboxnew(2)+bboxnew(4)-1,bboxnew(1):bboxnew(1)+bboxnew(3)-1,1) = tester;

tester = im1(bboxnew(2):bboxnew(2)+bboxnew(4)-1,bboxnew(1):bboxnew(1)+bboxnew(3)-1,2)
tester(tester&specrbin) = specr(tester&specrbin)
im1(bboxnew(2):bboxnew(2)+bboxnew(4)-1,bboxnew(1):bboxnew(1)+bboxnew(3)-1,2) = tester;

tester = im1(bboxnew(2):bboxnew(2)+bboxnew(4)-1,bboxnew(1):bboxnew(1)+bboxnew(3)-1,3)
tester(tester&specrbin) = specr(tester&specrbin)
im1(bboxnew(2):bboxnew(2)+bboxnew(4)-1,bboxnew(1):bboxnew(1)+bboxnew(3)-1,3) = tester;


thugIm = im1;

end