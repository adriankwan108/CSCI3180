#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct course_str{
    char  courseID[1][6];
    char  required[3][16];
    char  optional[5][16];
} course;

typedef struct ta_str{
    char taID[1][12];
    char taSkills[8][16];
    char taPrefer[3][6];
} ta;

typedef struct scoreStrorage_ptr{
    char* ID;
    double score;
} sStore;

//global variables
    FILE* f_i_ptr;
    FILE* f_c_ptr;
    FILE* out_ptr;
    int instructorNum;
    int candidatesNum;
    char defOutput[12] = "0000000000 "; //default output

int findLength(FILE* fd)
{
    int length=0;
    char buffer;

    while((buffer = fgetc(fd))!=EOF)
    {
        //printf("%c",buffer);
        if(buffer == '\n')
        {
            //printf("\n");
            length ++;
        }
    }
    rewind(fd);
    return length;
}

double validity(course cInput, ta taInput)
{
    int i,j;
    double valid=0.0f;
    for(i=0;i<3;i++) //for required skill
    {
        for(j=0;j<8;j++) //check for each TA skills
        {
            if(strcmp(cInput.required[i], taInput.taSkills[j])==0)
            {
                valid += 1.0f;
            }
            //printf("%s %s\n", cInput.required[i], taInput.taSkills[j]);
            //printf("%d %d valid = %f\n", i, j, valid);
        }
    }
    if(valid<3.0f)
    {
        valid = 0.0f; //not valid
    }
    else{
        valid = 1.0f;
    }
    return valid;
}

double optional(course cInput, ta taInput)
{
    double score=0.0f;
    int i,j;
    for(i=0;i<5;i++) //for each optional skill
    {
        for(j=0;j<8;j++) //check for each TA skills
        {
            if(strcmp(cInput.optional[i], taInput.taSkills[j])==0)
            {
                score+=1.0f;
            }
        }
    }
    return score;
}

double preference(course cInput, ta taInput)
{
    double score = 1.5f;
    int i;
    for(i=0;i<3;i++)
    {
        if(strcmp(cInput.courseID[0], taInput.taPrefer[i])==0)
        {
            return score;
        }
        score -=0.5f;
    }
    return score;
}

double scoreCal(course cInput, ta taInput)
{
    double result=0.0f;
    if((result=(validity(cInput,taInput)))==0.0f)  //check if valid,
    {
        result = 0.0f; //not valid, zero marks any way
    }
    else{
        result += optional(cInput, taInput);
        result += preference(cInput, taInput);
    }
    //printf("result = %f\n", result);
    return result;
}

void swapData(double* bufferX, double* bufferY)
{
    double temp;
    temp = *bufferX;
    *bufferX = *bufferY;
    *bufferY = temp;
}

void swapID(sStore bufferX, sStore bufferY)
{
    //printf("bufferX before = %s  score = %f\n", bufferX.ID, bufferX.score);
    //printf("bufferY before = %s  score = %f\n\n", bufferY.ID, bufferY.score);
    char* temp = (char*)malloc((15)*sizeof(char));
    strcpy(temp, bufferX.ID);
    strcpy(bufferX.ID,bufferY.ID);
    strcpy(bufferY.ID,temp);

    //printf("bufferX after = %s  score = %f\n", bufferX.ID, bufferX.score);
    //printf("bufferY after = %s  score = %f\n\n", bufferY.ID, bufferY.score);
    free(temp);
}

void bubbleSort(sStore buffer[])
{
    int i,j;
    int k,m;
    for(i=0;i<candidatesNum;i++)
    {
        for(j=0;j<(candidatesNum-1);j++)
        {
            //printf("buffer ID: %s score = %f.\n", buffer[0].ID,buffer[0].score);

            sscanf(buffer[j].ID,"%d",&k);
            sscanf(buffer[j+1].ID, "%d", &m);

            if(buffer[j+1].score>buffer[j].score || ((buffer[j+1].score==buffer[j].score)&&(k>m)))
            {
                //printf("buffer[j]= %f, buffer[j+1]= %f\n", buffer[j].score, buffer[j+1].score);
                swapID((buffer[j]),buffer[j+1]);
                swapData(&(buffer[j].score), &(buffer[j+1].score));
            }
        }
        //printf("one cycle\n");
    }
}

void printResult(course cInput[], ta taInput[])
{
    int i,j,k;

    sStore buffer[candidatesNum];

    for(i=0;i<instructorNum;i++) //for each course
    {
        //printf("course start\noriginal:\n");
        for(j=0;j<candidatesNum;j++) //for each TAs
        {
            buffer[j].ID = (char*)malloc(12*sizeof(char));
        }

        for(j=0;j<candidatesNum;j++) //for each TAs
        {
            buffer[j].score=scoreCal(cInput[i],taInput[j]);
            //printf("taInput[%d].taID[0]= %s\n", j, taInput[j].taID[0]);
            strcpy(buffer[j].ID ,taInput[j].taID[0]);
            //printf("%s %f.\n", buffer[j].ID,buffer[j].score);
        }

        bubbleSort(buffer);
        //printf("After:\n");
/*
        for(k=0;k<candidatesNum;k++) //for each TAs
        {
            printf("%s %f.\n", buffer[k].ID,buffer[k].score);
        }
        printf("\n");
*/
        fprintf(out_ptr,"%s", cInput[i].courseID[0]);
        for(k=0;k<3;k++)
        {
            if(buffer[k].score==0.0f)
            {
                fprintf(out_ptr,"%s",defOutput);
            }
            else{
                fprintf(out_ptr,"%s",buffer[k].ID);
            }
        }
        fprintf(out_ptr,"\n");
        free(buffer);
    }
}

void getCourseComponent(course* input,FILE* fd)
{
    int i,j;
    for(i=0;i<instructorNum;i++)
    {
        fgets(input[i].courseID[0],6,fd);
        for(j=0;j<3;j++)
        {
            fgets(input[i].required[j],16,fd);
            //printf("input[%d].required[%d]= %s\n", i,j, input[i].required[j]);
        }
        for(j=0;j<5;j++)
        {
            fgets(input[i].optional[j],16,fd);
        }
        fgetc(fd); //next line
    }
    rewind(fd);
}

void getTaComponent(ta* teacher, FILE* fk)
{
    for(int i=0;i<candidatesNum;i++)
    {
        fgets(teacher[i].taID[0],12,fk);
        for(int j=0;j<8;j++)
        {
            fgets(teacher[i].taSkills[j],16,fk);
        }
        for(int j=0;j<3;j++)
        {
            fgets(teacher[i].taPrefer[j],6,fk);
        }
        fgetc(fk);
    }
    rewind(fk);
}

void printComponent(course* cInput,ta* taInput)
{
    for(int q=0;q<instructorNum;q++)
    {
        printf("courseID = %s.\n", cInput[q].courseID[0]);
        for(int k=0;k<3;k++)
        {
            printf("required = %s.\n", cInput[q].required[k]);
        }
        for(int k=0;k<5;k++)
        {
            printf("optional = %s.\n", cInput[q].optional[k]);
        }
        printf("\n");
    }

    for(int q=0;q<candidatesNum;q++)
    {
        printf("taID = %s.\n", taInput[q].taID[0]);
        for(int k=0;k<8;k++)
        {
            printf("skills = %s.\n", taInput[q].taSkills[k]);
        }
        for(int k=0;k<3;k++)
        {
            printf("Preference = %s.\n", taInput[q].taPrefer[k]);
        }
        printf("\n");
    }
}

void outputEmpty(int flag) //cases of different approaches on exception
{
    int i;
    if(flag==0)
    {
        //printf("Empty instructors.txt file\n");
        fprintf(out_ptr,"\r\n");
    }else if(flag==1)
    {
        //printf("Empty candidates.txt file.\n");
        course iD[instructorNum];
        getCourseComponent(iD, f_i_ptr);

        sStore buffer[instructorNum];
        for(i=0; i<instructorNum;i++) //for each course
        {
            //save course ID to the buffer

            buffer[i].ID = iD[i].courseID[0];

        }
        for(i=0; i<instructorNum;i++)
        {
            fprintf(out_ptr,"%s%s%s%s\n",buffer[i].ID, defOutput, defOutput,defOutput);
        }
    }
    fclose(f_i_ptr);
    fclose(f_c_ptr);
    fclose(out_ptr);
    exit(0);
}

int initialization()
{
    int result = 0;
    instructorNum = findLength(f_i_ptr);
    candidatesNum = findLength(f_c_ptr);

    //printf("course: %d\n", instructorNum);
    //printf("TA: %d\n", candidatesNum);

    if(instructorNum<1)
    {
        outputEmpty(0);
        return result;
    }
    if(candidatesNum<1)
    {
        outputEmpty(1);
        return result;
    }

    result = 1;
    return result;
}

int main()
{
    //open and exception handling
    if((f_i_ptr = fopen("instructors.txt", "r"))==NULL)
    {
        printf("non-existing file!");
        exit(0);
        return 0;
    }

    if((f_c_ptr = fopen("candidates.txt", "r"))==NULL)
    {
        printf("non-existing file!");
        exit(0);
        return 0;
    }

    if((out_ptr = fopen("output.txt", "w"))==NULL)
    {
        printf("Create output.txt fail!");
        exit(0);
        return 0;
    }

    if(initialization()==0) //initialize failed/exception case == 0
    {
        //printf("initialization failed!");
        return 0;
    }

    //non-empty, exist, declare course array
    course cInput[instructorNum];
    ta taInput[candidatesNum];

    //assign value to those array
    getCourseComponent(cInput,f_i_ptr);
    getTaComponent(taInput, f_c_ptr);

    //printComponent(cInput, taInput);  //for testing
    printResult(cInput, taInput);

    fclose(f_i_ptr);
    fclose(f_c_ptr);
    fclose(out_ptr);

    return 0;
}


