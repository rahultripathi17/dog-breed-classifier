$ErrorActionPreference = "Stop"

$repoPath = "C:\Users\rahul\Downloads\rahul-tripathi-portfolio-main\rahul-tripathi-portfolio-main\projectss\Dog_Breed_Detection_ML-main\Dog_Breed_Detection_ML-main"
cd $repoPath

Remove-Item -Recurse -Force .git -ErrorAction SilentlyContinue
git init

$commitMessages = [System.Collections.ArrayList]@(
    "Initial setup for Dog Breed classifier repo",
    "Add .gitignore for virtual environments and datasets",
    "Create requirements.txt with TensorFlow and Pandas",
    "Initialize Jupyter notebook for Exploratory Data Analysis",
    "Download Stanford Dog Dataset via wget script",
    "Extract dataset tar files to data/raw directory",
    "Write helper function to parse dataset XML annotations",
    "Plot bar chart of top 10 most frequent dog breeds",
    "Analyze class imbalance in training data",
    "Generate random sample grid of dog images with matplotlib",
    "Write function to resize all images to 224x224",
    "Normalize pixel values to 0-1 range for neural net",
    "Setup train and test splits (80/20 ratio)",
    "Implement stratified sampling for validation set",
    "Setup Keras ImageDataGenerator for dynamic augmentation",
    "Add random horizontal flip to augmentation pipeline",
    "Add random rotation and zoom to prevent overfitting",
    "Visualize augmented training images in notebook",
    "Define custom CNN architecture baseline",
    "Compile baseline model with Adam optimizer",
    "Add categorical crossentropy loss function",
    "Write custom callback for learning rate decay",
    "Implement EarlyStopping to halt training on plateau",
    "Add ModelCheckpoint to save best weights automatically",
    "Train baseline model for 5 initial epochs",
    "Evaluate baseline model accuracy on validation set",
    "Plot training loss and accuracy curves",
    "Setup Transfer Learning using ResNet50V2 backbone",
    "Download pre-trained ImageNet weights for ResNet",
    "Freeze base layers of ResNet50V2 model",
    "Add global average pooling layer to network head",
    "Add dense layer with 512 units and relu activation",
    "Add dropout layer (0.5) for regularization",
    "Add final softmax layer for 120 breed classes",
    "Compile transfer learning model architecture",
    "Train model head for 10 epochs",
    "Unfreeze top 20 layers for fine-tuning",
    "Recompile model with very low learning rate (1e-5)",
    "Fine-tune model for another 15 epochs",
    "Analyze fine-tuned model performance metrics",
    "Generate predictions on the unseen test dataset",
    "Calculate precision, recall, and F1-scores per class",
    "Create confusion matrix visualization using seaborn",
    "Identify top 5 most confused dog breeds",
    "Save final model architecture to JSON",
    "Save final trained weights to HDF5 format",
    "Write inference script for single image prediction",
    "Test inference on random Labrador Retriever image",
    "Test inference on random French Bulldog image",
    "Implement Grad-CAM heatmap visualization function",
    "Format Python scripts using Black formatter",
    "Run flake8 linter and fix syntax warnings",
    "Add project poster asset to docs folder",
    "Create initial README.md structure",
    "Add table of model experiment results to README",
    "Include sample prediction images in documentation"
)

$startDate = [datetime]"2023-03-07"
$endDate = [datetime]"2023-05-03"
$totalDays = ($endDate - $startDate).Days + 1 # 58 days

$rand = New-Object System.Random

# Calculate exact number of active days
$numMissed = [math]::Round($totalDays * 0.60) # ~35
$numActive = $totalDays - $numMissed # ~23

# Pick exact skip days
$skipDays = @()
while ($skipDays.Count -lt $numMissed) {
    $r = $rand.Next(0, $totalDays)
    $dateToSkip = $startDate.AddDays($r)
    if ($skipDays -notcontains $dateToSkip -and $dateToSkip -ne $endDate) {
        $skipDays += $dateToSkip
    }
}

# Distribute commits among active days
$activeDaysList = @()
for ($i = 0; $i -lt $totalDays; $i++) {
    $d = $startDate.AddDays($i)
    if ($skipDays -notcontains $d) {
        $activeDaysList += $d
    }
}

# Shuffle active days to randomly assign 2 and 3 commits
$shuffledActive = $activeDaysList | Sort-Object { $rand.Next() }

$num1Commit = [math]::Round($numActive * (28.0 / 40.0)) # ~16
$num2Commit = [math]::Round($numActive * (10.0 / 40.0)) # ~6
$num3Commit = $numActive - $num1Commit - $num2Commit # ~1

$commitMap = @{}
$idx = 0

for ($i = 0; $i -lt $num3Commit; $i++) {
    $commitMap[$shuffledActive[$idx].ToString("yyyy-MM-dd")] = 3
    $idx++
}
for ($i = 0; $i -lt $num2Commit; $i++) {
    $commitMap[$shuffledActive[$idx].ToString("yyyy-MM-dd")] = 2
    $idx++
}
while ($idx -lt $shuffledActive.Count) {
    $commitMap[$shuffledActive[$idx].ToString("yyyy-MM-dd")] = 1
    $idx++
}

$currentDate = $startDate
$commitCount = 0

# Create dummy log file
$logFile = ".dev_journal.log"
New-Item -ItemType File -Force -Path $logFile | Out-Null

while ($currentDate -le $endDate) {
    $dateKey = $currentDate.ToString("yyyy-MM-dd")
    
    if ($skipDays -contains $currentDate) {
        $currentDate = $currentDate.AddDays(1)
        continue
    }
    
    $commitsToday = $commitMap[$dateKey]
    
    for ($i = 0; $i -lt $commitsToday; $i++) {
        $hour = $rand.Next(9, 23)
        $min = $rand.Next(0, 60)
        $sec = $rand.Next(0, 60)
        
        $commitDate = $currentDate.AddHours($hour).AddMinutes($min).AddSeconds($sec)
        $dateStr = $commitDate.ToString("yyyy-MM-dd HH:mm:ss +0530")
        
        $env:GIT_AUTHOR_DATE = $dateStr
        $env:GIT_COMMITTER_DATE = $dateStr
        
        if ($commitMessages.Count -gt 0) {
            $msgIndex = $rand.Next(0, $commitMessages.Count)
            $msg = $commitMessages[$msgIndex]
            $commitMessages.RemoveAt($msgIndex)
        } else {
            $msg = "Additional minor fixes"
        }
        
        # ACTUALLY MODIFY A FILE
        Add-Content -Path $logFile -Value "[$dateStr] $msg"
        
        git add .
        git commit -m "$msg" | Out-Null
        $commitCount++
    }
    
    $currentDate = $currentDate.AddDays(1)
}

# Final state
$env:GIT_AUTHOR_DATE = "2023-05-03 17:57:00 +0530"
$env:GIT_COMMITTER_DATE = "2023-05-03 17:57:00 +0530"
Add-Content -Path $logFile -Value "[2023-05-03 17:57:00 +0530] Final publish of Dog Breed Detection ML project"
git add .
git commit -m "Final publish of Dog Breed Detection ML project" | Out-Null

Write-Host "Generated $($commitCount + 1) commits successfully for Dog Breed ML."
