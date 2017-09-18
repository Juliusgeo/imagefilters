#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv/cvaux.hpp>
#include <opencv2/imgproc/imgproc.hpp>


int accumulate(float kernel[3][3], float imslice[3][3]){
	float sum;
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
		return (int)sum;
	}
}

int main()
{
	cv::Mat imarray;
	cv::Mat colorMat = cv::imread("lenna.png", CV_LOAD_IMAGE_UNCHANGED);
	cv::cvtColor(colorMat, imarray, cv::COLOR_BGR2GRAY);
	cv::Mat copy=imarray.clone();
	//float kernel[3][3]={{-1,-1,-1},{-1,8,-1},{-1,-1,-1}};
	float kernel[3][3]={{.0625,.125,.062},{.125,.25,.125},{.062,.125,.062}};
	float imslice[3][3];
	for(int j=1;j<imarray.rows-1;j++)
	{
		for (int i=1;i<imarray.cols-1;i++)
		{
			for(int x=0;x<3;x++)
			{
				for (int y=0;y<3;y++)
				{
					imslice[x][y]=(int)imarray.at<uchar>(j-1+x,i-1+y);
				}
			}
			//std::cout << imslice;
			std::cout << "";
			copy.at<uchar>(j,i)=accumulate(kernel,imslice);
		}
	}
	//After changing
	//cv::imshow("After",copy);
	//cv::waitKey(2000);
	cv::imwrite("out.jpg", copy );
	//imarray.release();
	//copy.release();
  	return 0;
}
