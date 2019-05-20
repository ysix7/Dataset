# BSDS500/300 

这两个是berkely （伯克利大学）computer vision group提供的数据集，用来做segmentation**（图像分割）**或contour detection**（轮廓检测）**的，还有人拿这个做super resolution**（超分重建**）的

数据库包含200张训练图，200张侧视图，100张检验图。ground truth是人工标识的，已数据库图片id为单位，保存成mat格式文件，一个文件包含多个标记者的标记信息。有轮廓和分割信息，用matlab读取很方便，直接load就行。

## 下载地址

[数据库下载链接](<https://blog.csdn.net/u014722627/article/details/60140789>)

## 读取脚本

生成轮廓可视化图：

```matlab
% make_gt_bondary_image.m
% bsdsRoot 需包含train、test 两个文件夹，生成的结果也放在这两个文件夹的bon子文件夹里
state = 'test';%修改为test或train，分别处理两个文件夹 
file_list = dir(fullfile(bsdsRoot,state,'*.mat'));%获取该文件夹中所有jpg格式的图像
for i=1:length(file_list)
    mat = load(file_list(i).name);
    [~,image_name,~] = fileparts(file_list(i).name);
    gt = mat.groundTruth;
    for gtid=1:length(gt)
        bmap = gt{gtid}.Boundaries;
        if gtid==1
            image = bmap;
        else
            image(bmap==true)=true;
        end

    end
    %黑底白边
    imwrite(double(image),fullfile(bsdsRoot,'bon',state,[image_name '.jpg']));
    %白底黑边
    %imwrite(1-double(image),fullfile(bsdsRoot,state,'bon',[image_name '.jpg']));

end
```

生成分块可视化：

```matlab
% make_gt_seg_image.m
% bsdsRoot 需包含train、test 两个文件夹，生成的结果也放在这两个文件夹的seg子文件夹里
state = 'train';
file_list = dir(fullfile(bsdsRoot,state,'*.mat'));%获取该文件夹中所有jpg格式的图像
for i=1:length(file_list)
    mat = load(file_list(i).name);
    [~,image_name,~] = fileparts(file_list(i).name);
    gt = mat.groundTruth;
    for gtid=1:length(gt)
        seg = double(gt{gtid}.Segmentation);
        seg = seg/max(max(seg));
        if gtid == 1
            image = seg;
        else
            image = image+seg;
        end
    end
    image = image/length(gt);
    imwrite(double(image),fullfile(bsdsRoot,state,'seg',[image_name '.jpg']));

end
```

# BSD68

Color BSD68 dataset for image denoising benchmarks It is part of The Berkeley Segmentation Dataset and Benchmark. This benchmark dataset is widely used for measuring image denoising algorithms performance.

- [下载链接](https://github.com/clausmichele/CBSD68-dataset)
- 

# Set12

- [下载地址](https://github.com/visinf/n3net/tree/master/datasets)
- 十二张图名字
- 特点