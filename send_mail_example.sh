#!/bin/bash

message=$1
{
    echo To: recipient@emailadress
    echo From: InsertName
    echo Subject: InsertSubject
    echo $message
    } | ssmtp recipient@emailadress
