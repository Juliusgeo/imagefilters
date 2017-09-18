#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv/cvaux.hpp>
#include <opencv2/imgproc/imgproc.hpp>


int accumulate(int kernel[3][3], int imslice[3][3]){
	int sum;
	for(int j=0;j<3;j++)
	{
		for (int i=0;i<3;i++)
		{
			sum+=kernel[j][i]*imslice[j][i];
		}
	}
	if(sum>255){
		return 255;
	}
	else if(sum<0){
		return 0;
	}
	else{
	return sum;}
}

int main(int argc, char** argv)
{	cv::Mat imarray;
	cv::Mat colorMat = cv::imread("Lenna.png", CV_LOAD_IMAGE_UNCHANGED);
	cv::cvtColor(colorMat, imarray, cv::COLOR_BGR2GRAY);
	cv::Mat copy=imarray.clone();
	int kernel[3][3]={{-1,-1,-1},{-1,9,-1},{-1,-1,-1}};
	int imslice[3][3];
	for(int j=1;j<imarray.rows-1;j++)
	{
		for (int i=1;i<imarray.cols-1;i++)
		{
			imslice[0][0]=(int)imarray.at<uchar>(j-1,i-1);
			imslice[0][1]=(int)imarray.at<uchar>(j-1,i);
			imslice[0][2]=(int)imarray.at<uchar>(j-1,i+1);
			imslice[1][0]=(int)imarray.at<uchar>(j,i-1);
			imslice[1][1]=(int)imarray.at<uchar>(j,i);
			imslice[1][2]=(int)imarray.at<uchar>(j,i+1);
			imslice[2][0]=(int)imarray.at<uchar>(j+1,i-1);
			imslice[2][1]=(int)imarray.at<uchar>(j+1,i);
			imslice[2][2]=(int)imarray.at<uchar>(j+1,i+1);
			//std::cout << imslice;
			std::cout << "";
			copy.at<uchar>(j,i)=accumulate(kernel,imslice);
		}
	}
//After changing
	//cv::imshow("After",copy);
	//cv::waitKey(2);
	cv::imwrite( "Lenna2.png", copy );
	imarray.release();
	copy.release();
  return 0;
}